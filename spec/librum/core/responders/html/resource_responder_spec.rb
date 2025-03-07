# frozen_string_literal: true

require 'rails_helper'

require 'stannum/errors'

require 'cuprum/collections'
require 'cuprum/rails/rspec/contracts/responder_contracts'

require 'support/rocket'

RSpec.describe Librum::Core::Responders::Html::ResourceResponder do
  include Cuprum::Rails::RSpec::Contracts::ResponderContracts
  include Librum::Core::RSpec::Contracts::Responders::HtmlContracts

  subject(:responder) { described_class.new(**constructor_options) }

  shared_context 'when the page is defined' do |component_name|
    let(:component_class) { component_name.constantize }

    example_class component_name, Librum::Core::View::Components::Page
  end

  shared_context 'when the resource has ancestors' do
    let(:space_programs_resource) do
      Cuprum::Rails::Resource.new(name: 'space_programs')
    end
    let(:missions_resource) do
      Cuprum::Rails::Resource.new(
        name:   'missions',
        parent: space_programs_resource
      )
    end
    let(:resource_options) { super().merge(parent: missions_resource) }
    let(:path_params) do
      {
        'space_program_id' => 'morningstar-technologies',
        'mission_id'       => 'imp',
        'id'               => 'imp-iv'
      }
    end
    let(:request) do
      Cuprum::Rails::Request.new(
        action_name: action_name,
        path_params: path_params
      )
    end
  end

  shared_examples 'should respond with the page when defined' \
  do |component_name, lazy_require: false, **options|
    wrap_context 'when the page is defined', component_name do
      let(:expected_path) do
        component_name.split('::').map(&:underscore).join('/')
      end

      include_contract 'should render page',
        component_name,
        **options

      if lazy_require
        it 'should lazily require the resource page' do
          responder.call(result)

          expect(responder)
            .to have_received(:require)
            .with(expected_path)
        end

        context 'when the resource page cannot be required' do
          before(:example) do
            allow(responder).to receive(:require).and_raise(LoadError)
          end

          include_contract 'should render page',
            component_name,
            **options
        end
      end
    end
  end

  let(:action_name)   { 'implement' }
  let(:controller)    { CustomController.new }
  let(:member_action) { false }
  let(:request)       { Cuprum::Rails::Request.new }
  let(:resource_options) do
    { name: 'rockets' }
  end
  let(:constructor_options) do
    {
      action_name:   action_name,
      controller:    controller,
      member_action: member_action,
      request:       request
    }
  end

  include_contract 'should implement the responder methods',
    controller_name: 'CustomController'

  # rubocop:disable RSpec/MultipleMemoizedHelpers
  describe '#call' do
    shared_examples 'should handle a failing result' do |action|
      describe 'with a failing result' do
        let(:error)  { Cuprum::Error.new(message: 'Something went wrong') }
        let(:result) { Cuprum::Result.new(error: error) }

        include_contract 'should render the missing page'

        include_examples 'should respond with the page when defined',
          "View::Pages::Custom::#{action}Page",
          http_status: :internal_server_error

        include_examples 'should respond with the page when defined',
          "View::Pages::Resources::#{action}Page",
          http_status: :internal_server_error

        include_examples 'should respond with the page when defined',
          "Librum::Core::View::Pages::Resources::#{action}Page",
          http_status:  :internal_server_error,
          lazy_require: true
      end
    end

    shared_examples 'should handle a result with a NotFound error' \
    do |component_name, with_ancestors: false, with_resource: true|
      describe 'with a failing result with a NotFound error' do
        let(:result) { Cuprum::Result.new(error: error) }

        context 'when the error does not match a resource' do
          let(:error) do
            Cuprum::Collections::Errors::NotFound.new(
              attribute_name:  'slug',
              attribute_value: 'cythera',
              collection_name: 'planets',
              primary_key:     true
            )
          end

          include_contract 'should render the missing page',
            flash: {
              warning: {
                icon:    'exclamation-triangle',
                message: 'Planet not found with key "cythera"'
              }
            }

          include_examples 'should respond with the page when defined',
            component_name,
            flash:       {
              warning: {
                icon:    'exclamation-triangle',
                message: 'Planet not found with key "cythera"'
              }
            },
            http_status: :not_found
        end

        if with_resource
          context 'when the error matches the resource' do
            let(:error) do
              Cuprum::Collections::Errors::NotFound.new(
                attribute_name:  'slug',
                attribute_value: 'imp-iv',
                collection_name: 'rockets'
              )
            end
            let(:response_class) do
              Cuprum::Rails::Responses::Html::RedirectResponse
            end
            let(:expected_flash) do
              {
                warning: {
                  icon:    'exclamation-triangle',
                  message: 'Rocket not found with key "imp-iv"'
                }
              }
            end
            let(:expected_path) do
              resource
                .routes
                .with_wildcards(request.path_params || {})
                .index_path
            end

            it { expect(response).to be_a response_class }

            it { expect(response.flash).to be == expected_flash }

            it { expect(response.path).to be == expected_path }

            it { expect(response.status).to be 302 } # rubocop:disable RSpecRails/HaveHttpStatus
          end
        end

        if with_ancestors
          context 'when the error matches the parent resource' do
            let(:error) do
              Cuprum::Collections::Errors::NotFound.new(
                attribute_name:  'slug',
                attribute_value: 'imp',
                collection_name: 'mission'
              )
            end
            let(:response_class) do
              Cuprum::Rails::Responses::Html::RedirectResponse
            end
            let(:expected_flash) do
              {
                warning: {
                  icon:    'exclamation-triangle',
                  message: 'Mission not found with key "imp"'
                }
              }
            end
            let(:expected_path) do
              missions_resource
                .routes
                .with_wildcards(request.path_params)
                .index_path
            end

            it { expect(response).to be_a response_class }

            it { expect(response.flash).to be == expected_flash }

            it { expect(response.path).to be == expected_path }

            it { expect(response.status).to be 302 } # rubocop:disable RSpecRails/HaveHttpStatus
          end

          context 'when the error matches the top-level resource' do
            let(:error) do
              Cuprum::Collections::Errors::NotFound.new(
                attribute_name:  'slug',
                attribute_value: 'morningstar-technologies',
                collection_name: 'space_program'
              )
            end
            let(:response_class) do
              Cuprum::Rails::Responses::Html::RedirectResponse
            end
            let(:expected_flash) do
              message =
                'Space Program not found with key "morningstar-technologies"'

              {
                warning: {
                  icon:    'exclamation-triangle',
                  message: message
                }
              }
            end
            let(:expected_path) do
              space_programs_resource
                .routes
                .with_wildcards(request.path_params)
                .index_path
            end

            it { expect(response).to be_a response_class }

            it { expect(response.flash).to be == expected_flash }

            it { expect(response.path).to be == expected_path }

            it { expect(response.status).to be 302 } # rubocop:disable RSpecRails/HaveHttpStatus
          end
        end
      end
    end

    let(:controller_name) { 'CustomController' }
    let(:result)          { Cuprum::Result.new }
    let(:response)        { responder.call(result) }
    let(:expected_page) do
      'View::Pages::Custom::ImplementPage'
    end

    before(:example) { allow(responder).to receive(:require) } # rubocop:disable RSpec/SubjectStub

    context 'when initialized with a plural resource' do
      include_examples 'should handle a failing result', 'Implement'

      include_examples 'should handle a result with a NotFound error',
        'View::Pages::Custom::ImplementPage'

      describe 'with a passing result' do
        let(:value)  { { ok: true } }
        let(:result) { Cuprum::Result.new(value: value) }

        include_contract 'should render the missing page'

        include_examples 'should respond with the page when defined',
          'View::Pages::Custom::ImplementPage'

        include_examples 'should respond with the page when defined',
          'View::Pages::Resources::ImplementPage'

        include_examples 'should respond with the page when defined',
          'Librum::Core::View::Pages::Resources::ImplementPage',
          lazy_require: true
      end

      wrap_context 'when the resource has ancestors' do
        include_examples 'should handle a failing result', 'Implement'

        include_examples 'should handle a result with a NotFound error',
          'View::Pages::Custom::ImplementPage',
          with_ancestors: true

        describe 'with a passing result' do
          let(:value)  { { ok: true } }
          let(:result) { Cuprum::Result.new(value: value) }

          include_contract 'should render the missing page'

          include_examples 'should respond with the page when defined',
            'View::Pages::Custom::ImplementPage'

          include_examples 'should respond with the page when defined',
            'View::Pages::Resources::ImplementPage'

          include_examples 'should respond with the page when defined',
            'Librum::Core::View::Pages::Resources::ImplementPage',
            lazy_require: true
        end
      end

      context 'when initialized with action_name: "create"' do
        let(:action_name)   { 'create' }
        let(:expected_page) { 'View::Pages::Custom::CreatePage' }

        include_examples 'should handle a failing result', 'Create'

        include_examples 'should handle a result with a NotFound error',
          'View::Pages::Custom::CreatePage'

        describe 'with a failing result with a FailedValidation error' do
          let(:error) do
            Cuprum::Collections::Errors::FailedValidation.new(
              entity_class: Spec::Support::Rocket,
              errors:       Stannum::Errors.new
            )
          end
          let(:result) { Cuprum::Result.new(error: error) }

          include_contract 'should render page',
            'Librum::Core::View::Pages::Resources::NewPage',
            flash: lambda {
              {
                warning: {
                  icon:    'exclamation-triangle',
                  message: 'Unable to create Rocket'
                }
              }
            }
        end

        describe 'with a passing result' do
          let(:rocket) do
            Spec::Support::Rocket.new(
              name: 'Imp IV',
              slug: 'imp-iv'
            )
          end
          let(:value)  { { 'rocket' => rocket } }
          let(:result) { Cuprum::Result.new(value: value) }

          include_contract 'should redirect to',
            '/rockets/imp-iv',
            flash: lambda {
              {
                success: {
                  icon:    'circle-check',
                  message: 'Successfully created Rocket'
                }
              }
            }
        end

        wrap_context 'when the resource has ancestors' do
          include_examples 'should handle a failing result', 'Create'

          include_examples 'should handle a result with a NotFound error',
            'View::Pages::Custom::CreatePage',
            with_ancestors: true

          describe 'with a failing result with a FailedValidation error' do # rubocop:disable RSpec/NestedGroups
            let(:error) do
              Cuprum::Collections::Errors::FailedValidation.new(
                entity_class: Spec::Support::Rocket,
                errors:       Stannum::Errors.new
              )
            end
            let(:result) { Cuprum::Result.new(error: error) }

            include_contract 'should render page',
              'Librum::Core::View::Pages::Resources::NewPage',
              flash: lambda {
                {
                  warning: {
                    icon:    'exclamation-triangle',
                    message: 'Unable to create Rocket'
                  }
                }
              }
          end

          describe 'with a passing result' do # rubocop:disable RSpec/NestedGroups
            let(:rocket) do
              Spec::Support::Rocket.new(
                name: 'Imp IV',
                slug: 'imp-iv'
              )
            end
            let(:value)  { { 'rocket' => rocket } }
            let(:result) { Cuprum::Result.new(value: value) }

            resource_url =
              '/space_programs/morningstar-technologies/missions/imp/rockets'
            include_contract 'should redirect to',
              "#{resource_url}/imp-iv",
              flash: lambda {
                {
                  success: {
                    icon:    'circle-check',
                    message: 'Successfully created Rocket'
                  }
                }
              }
          end
        end
      end

      context 'when initialized with action_name: "destroy"' do
        let(:action_name)   { 'destroy' }
        let(:expected_page) { 'View::Pages::Custom::DestroyPage' }

        describe 'with a failing result' do
          let(:error)  { Cuprum::Error.new(message: 'Something went wrong') }
          let(:result) { Cuprum::Result.new(error: error) }

          include_contract 'should redirect back',
            flash: lambda {
              {
                warning: {
                  icon:    'exclamation-triangle',
                  message: 'Unable to destroy Rocket'
                }
              }
            }
        end

        describe 'with a passing result' do
          let(:result) { Cuprum::Result.new }

          include_contract 'should redirect to',
            '/rockets',
            flash: lambda {
              {
                danger: {
                  icon:    'bomb',
                  message: 'Successfully destroyed Rocket'
                }
              }
            }
        end

        wrap_context 'when the resource has ancestors' do
          describe 'with a failing result' do # rubocop:disable RSpec/NestedGroups
            let(:error)  { Cuprum::Error.new(message: 'Something went wrong') }
            let(:result) { Cuprum::Result.new(error: error) }

            include_contract 'should redirect back',
              flash: lambda {
                {
                  warning: {
                    icon:    'exclamation-triangle',
                    message: 'Unable to destroy Rocket'
                  }
                }
              }
          end

          include_examples 'should handle a result with a NotFound error',
            'View::Pages::Custom::DestroyPage',
            with_ancestors: true

          describe 'with a passing result' do # rubocop:disable RSpec/NestedGroups
            let(:result) { Cuprum::Result.new }

            resource_url =
              '/space_programs/morningstar-technologies/missions/imp/rockets'
            include_contract 'should redirect to',
              resource_url,
              flash: lambda {
                {
                  danger: {
                    icon:    'bomb',
                    message: 'Successfully destroyed Rocket'
                  }
                }
              }
          end
        end
      end

      context 'when initialized with action_name: "update"' do
        let(:action_name)   { 'update' }
        let(:expected_page) { 'View::Pages::Custom::UpdatePage' }

        include_examples 'should handle a failing result', 'Update'

        include_examples 'should handle a result with a NotFound error',
          'View::Pages::Custom::UpdatePage'

        describe 'with a failing result with a FailedValidation error' do
          let(:error) do
            Cuprum::Collections::Errors::FailedValidation.new(
              entity_class: Spec::Support::Rocket,
              errors:       Stannum::Errors.new
            )
          end
          let(:result) { Cuprum::Result.new(error: error) }

          include_contract 'should render page',
            'Librum::Core::View::Pages::Resources::EditPage',
            flash: lambda {
              {
                warning: {
                  icon:    'exclamation-triangle',
                  message: 'Unable to update Rocket'
                }
              }
            }
        end

        describe 'with a passing result' do
          let(:rocket) do
            Spec::Support::Rocket.new(
              name: 'Imp IV',
              slug: 'imp-iv'
            )
          end
          let(:value)  { { 'rocket' => rocket } }
          let(:result) { Cuprum::Result.new(value: value) }

          include_contract 'should redirect to',
            '/rockets/imp-iv',
            flash: lambda {
              {
                success: {
                  icon:    'circle-check',
                  message: 'Successfully updated Rocket'
                }
              }
            }
        end

        wrap_context 'when the resource has ancestors' do
          include_examples 'should handle a failing result', 'Update'

          include_examples 'should handle a result with a NotFound error',
            'View::Pages::Custom::UpdatePage',
            with_ancestors: true

          describe 'with a failing result with a FailedValidation error' do # rubocop:disable RSpec/NestedGroups
            let(:error) do
              Cuprum::Collections::Errors::FailedValidation.new(
                entity_class: Spec::Support::Rocket,
                errors:       Stannum::Errors.new
              )
            end
            let(:result) { Cuprum::Result.new(error: error) }

            include_contract 'should render page',
              'Librum::Core::View::Pages::Resources::EditPage',
              flash: lambda {
                {
                  warning: {
                    icon:    'exclamation-triangle',
                    message: 'Unable to update Rocket'
                  }
                }
              }
          end

          describe 'with a passing result' do # rubocop:disable RSpec/NestedGroups
            let(:rocket) do
              Spec::Support::Rocket.new(
                name: 'Imp IV',
                slug: 'imp-iv'
              )
            end
            let(:value)  { { 'rocket' => rocket } }
            let(:result) { Cuprum::Result.new(value: value) }

            resource_url =
              '/space_programs/morningstar-technologies/missions/imp/rockets'
            include_contract 'should redirect to',
              "#{resource_url}/imp-iv",
              flash: lambda {
                {
                  success: {
                    icon:    'circle-check',
                    message: 'Successfully updated Rocket'
                  }
                }
              }
          end
        end
      end
    end

    context 'when initialized with a singular resource' do
      let(:resource_options) { super().merge(name: 'rocket', singular: true) }

      include_examples 'should handle a failing result', 'Implement'

      include_examples 'should handle a result with a NotFound error',
        'View::Pages::Custom::ImplementPage',
        with_resource: false

      describe 'with a passing result' do
        let(:value)  { { ok: true } }
        let(:result) { Cuprum::Result.new(value: value) }

        include_contract 'should render the missing page'

        include_examples 'should respond with the page when defined',
          'View::Pages::Custom::ImplementPage'

        include_examples 'should respond with the page when defined',
          'View::Pages::Resources::ImplementPage'

        include_examples 'should respond with the page when defined',
          'Librum::Core::View::Pages::Resources::ImplementPage',
          lazy_require: true
      end

      wrap_context 'when the resource has ancestors' do
        include_examples 'should handle a failing result', 'Implement'

        include_examples 'should handle a result with a NotFound error',
          'View::Pages::Custom::ImplementPage',
          with_ancestors: true,
          with_resource:  false

        describe 'with a passing result' do
          let(:value)  { { ok: true } }
          let(:result) { Cuprum::Result.new(value: value) }

          include_contract 'should render the missing page'

          include_examples 'should respond with the page when defined',
            'View::Pages::Custom::ImplementPage'

          include_examples 'should respond with the page when defined',
            'View::Pages::Resources::ImplementPage'

          include_examples 'should respond with the page when defined',
            'Librum::Core::View::Pages::Resources::ImplementPage',
            lazy_require: true
        end
      end

      context 'when initialized with action_name: "create"' do
        let(:action_name)   { 'create' }
        let(:expected_page) { 'View::Pages::Custom::CreatePage' }

        include_examples 'should handle a failing result', 'Create'

        include_examples 'should handle a result with a NotFound error',
          'View::Pages::Custom::CreatePage',
          with_resource: false

        describe 'with a failing result with a FailedValidation error' do
          let(:error) do
            Cuprum::Collections::Errors::FailedValidation.new(
              entity_class: Spec::Support::Rocket,
              errors:       Stannum::Errors.new
            )
          end
          let(:result) { Cuprum::Result.new(error: error) }

          include_contract 'should render page',
            'Librum::Core::View::Pages::Resources::NewPage',
            flash: lambda {
              {
                warning: {
                  icon:    'exclamation-triangle',
                  message: 'Unable to create Rocket'
                }
              }
            }
        end

        describe 'with a passing result' do
          let(:rocket) do
            Spec::Support::Rocket.new(
              name: 'Imp IV',
              slug: 'imp-iv'
            )
          end
          let(:value)  { { 'rocket' => rocket } }
          let(:result) { Cuprum::Result.new(value: value) }

          include_contract 'should redirect to',
            '/rocket',
            flash: lambda {
              {
                success: {
                  icon:    'circle-check',
                  message: 'Successfully created Rocket'
                }
              }
            }
        end

        wrap_context 'when the resource has ancestors' do
          include_examples 'should handle a failing result', 'Create'

          include_examples 'should handle a result with a NotFound error',
            'View::Pages::Custom::CreatePage',
            with_ancestors: true,
            with_resource:  false

          describe 'with a failing result with a FailedValidation error' do # rubocop:disable RSpec/NestedGroups
            let(:error) do
              Cuprum::Collections::Errors::FailedValidation.new(
                entity_class: Spec::Support::Rocket,
                errors:       Stannum::Errors.new
              )
            end
            let(:result) { Cuprum::Result.new(error: error) }

            include_contract 'should render page',
              'Librum::Core::View::Pages::Resources::NewPage',
              flash: lambda {
                {
                  warning: {
                    icon:    'exclamation-triangle',
                    message: 'Unable to create Rocket'
                  }
                }
              }
          end

          describe 'with a passing result' do # rubocop:disable RSpec/NestedGroups
            let(:rocket) do
              Spec::Support::Rocket.new(
                name: 'Imp IV',
                slug: 'imp-iv'
              )
            end
            let(:value)  { { 'rocket' => rocket } }
            let(:result) { Cuprum::Result.new(value: value) }

            resource_url =
              '/space_programs/morningstar-technologies/missions/imp/rocket'
            include_contract 'should redirect to',
              resource_url,
              flash: lambda {
                {
                  success: {
                    icon:    'circle-check',
                    message: 'Successfully created Rocket'
                  }
                }
              }
          end
        end
      end

      context 'when initialized with action_name: "destroy"' do
        let(:action_name)   { 'destroy' }
        let(:expected_page) { 'View::Pages::Custom::DestroyPage' }

        describe 'with a failing result' do
          let(:error)  { Cuprum::Error.new(message: 'Something went wrong') }
          let(:result) { Cuprum::Result.new(error: error) }

          include_contract 'should redirect back',
            flash: lambda {
              {
                warning: {
                  icon:    'exclamation-triangle',
                  message: 'Unable to destroy Rocket'
                }
              }
            }
        end

        describe 'with a passing result' do
          let(:result) { Cuprum::Result.new }

          include_contract 'should redirect to',
            '/rocket',
            flash: lambda {
              {
                danger: {
                  icon:    'bomb',
                  message: 'Successfully destroyed Rocket'
                }
              }
            }
        end

        wrap_context 'when the resource has ancestors' do
          describe 'with a failing result' do # rubocop:disable RSpec/NestedGroups
            let(:error)  { Cuprum::Error.new(message: 'Something went wrong') }
            let(:result) { Cuprum::Result.new(error: error) }

            include_contract 'should redirect back',
              flash: lambda {
                {
                  warning: {
                    icon:    'exclamation-triangle',
                    message: 'Unable to destroy Rocket'
                  }
                }
              }
          end

          include_examples 'should handle a result with a NotFound error',
            'View::Pages::Custom::DestroyPage',
            with_ancestors: true,
            with_resource:  false

          describe 'with a passing result' do # rubocop:disable RSpec/NestedGroups
            let(:result) { Cuprum::Result.new }

            resource_url =
              '/space_programs/morningstar-technologies/missions/imp/rocket'
            include_contract 'should redirect to',
              resource_url,
              flash: lambda {
                {
                  danger: {
                    icon:    'bomb',
                    message: 'Successfully destroyed Rocket'
                  }
                }
              }
          end
        end
      end

      context 'when initialized with action_name: "update"' do
        let(:action_name)   { 'update' }
        let(:expected_page) { 'View::Pages::Custom::UpdatePage' }

        include_examples 'should handle a failing result', 'Update'

        include_examples 'should handle a result with a NotFound error',
          'View::Pages::Custom::UpdatePage',
          with_resource: false

        describe 'with a failing result with a FailedValidation error' do
          let(:error) do
            Cuprum::Collections::Errors::FailedValidation.new(
              entity_class: Spec::Support::Rocket,
              errors:       Stannum::Errors.new
            )
          end
          let(:result) { Cuprum::Result.new(error: error) }

          include_contract 'should render page',
            'Librum::Core::View::Pages::Resources::EditPage',
            flash: lambda {
              {
                warning: {
                  icon:    'exclamation-triangle',
                  message: 'Unable to update Rocket'
                }
              }
            }
        end

        describe 'with a passing result' do
          let(:rocket) do
            Spec::Support::Rocket.new(
              name: 'Imp IV',
              slug: 'imp-iv'
            )
          end
          let(:value)  { { 'rocket' => rocket } }
          let(:result) { Cuprum::Result.new(value: value) }

          include_contract 'should redirect to',
            '/rocket',
            flash: lambda {
              {
                success: {
                  icon:    'circle-check',
                  message: 'Successfully updated Rocket'
                }
              }
            }
        end

        wrap_context 'when the resource has ancestors' do
          include_examples 'should handle a failing result', 'Update'

          include_examples 'should handle a result with a NotFound error',
            'View::Pages::Custom::UpdatePage',
            with_ancestors: true,
            with_resource:  false

          describe 'with a failing result with a FailedValidation error' do # rubocop:disable RSpec/NestedGroups
            let(:error) do
              Cuprum::Collections::Errors::FailedValidation.new(
                entity_class: Spec::Support::Rocket,
                errors:       Stannum::Errors.new
              )
            end
            let(:result) { Cuprum::Result.new(error: error) }

            include_contract 'should render page',
              'Librum::Core::View::Pages::Resources::EditPage',
              flash: lambda {
                {
                  warning: {
                    icon:    'exclamation-triangle',
                    message: 'Unable to update Rocket'
                  }
                }
              }
          end

          describe 'with a passing result' do # rubocop:disable RSpec/NestedGroups
            let(:rocket) do
              Spec::Support::Rocket.new(
                name: 'Imp IV',
                slug: 'imp-iv'
              )
            end
            let(:value)  { { 'rocket' => rocket } }
            let(:result) { Cuprum::Result.new(value: value) }

            resource_url =
              '/space_programs/morningstar-technologies/missions/imp/rocket'
            include_contract 'should redirect to',
              resource_url,
              flash: lambda {
                {
                  success: {
                    icon:    'circle-check',
                    message: 'Successfully updated Rocket'
                  }
                }
              }
          end
        end
      end
    end
  end
  # rubocop:enable RSpec/MultipleMemoizedHelpers

  describe '#format' do
    include_examples 'should define reader', :format, :html
  end

  # rubocop:disable RSpec/MultipleMemoizedHelpers
  describe '#render_component' do
    let(:controller_name) { 'CustomController' }
    let(:result)          { Cuprum::Result.new }
    let(:options)         { {} }
    let(:response)        { responder.render_component(result, **options) }
    let(:expected_page)   { 'View::Pages::Custom::ImplementPage' }

    before(:example) { allow(responder).to receive(:require) } # rubocop:disable RSpec/SubjectStub

    it 'should define the method' do
      expect(responder)
        .to respond_to(:render_component)
        .with(1).argument
        .and_keywords(:flash, :status)
    end

    include_contract 'should render the missing page'

    include_examples 'should respond with the page when defined',
      'View::Pages::Custom::ImplementPage'

    include_examples 'should respond with the page when defined',
      'View::Pages::Resources::ImplementPage'

    include_examples 'should respond with the page when defined',
      'Librum::Core::View::Pages::Resources::ImplementPage'

    describe 'with action: value' do
      let(:action)  { 'execute' }
      let(:options) { super().merge(action: action) }

      include_contract 'should render the missing page'

      include_examples 'should respond with the page when defined',
        'View::Pages::Custom::ExecutePage'

      include_examples 'should respond with the page when defined',
        'View::Pages::Resources::ExecutePage'

      include_examples 'should respond with the page when defined',
        'Librum::Core::View::Pages::Resources::ExecutePage'
    end
    # rubocop:enable RSpec/MultipleMemoizedHelpers
  end
end
