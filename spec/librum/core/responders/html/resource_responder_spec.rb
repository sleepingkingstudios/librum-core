# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/collections'
require 'cuprum/rails/rspec/contracts/responder_contracts'

require 'librum/core/responders/html/resource_responder'
require 'librum/core/rspec/contracts/responders/html_contracts'

RSpec.describe Librum::Core::Responders::Html::ResourceResponder do
  include Cuprum::Rails::RSpec::Contracts::ResponderContracts
  include Librum::Core::RSpec::Contracts::Responders::HtmlContracts

  subject(:responder) { described_class.new(**constructor_options) }

  shared_context 'when the page is defined' do |component_name|
    let(:component_class) { component_name.constantize }

    example_class component_name, Librum::Core::View::Components::Page
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
  let(:resource)      { Cuprum::Rails::Resource.new(resource_name: 'rockets') }
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
    let(:controller_name) { 'CustomController' }
    let(:result)          { Cuprum::Result.new }
    let(:response)        { responder.call(result) }
    let(:expected_page) do
      'View::Pages::Custom::ImplementPage'
    end

    before(:example) { allow(responder).to receive(:require) } # rubocop:disable RSpec/SubjectStub

    describe 'with a failing result' do
      let(:error)  { Cuprum::Error.new(message: 'Something went wrong') }
      let(:result) { Cuprum::Result.new(error: error) }

      include_contract 'should render the missing page'

      include_examples 'should respond with the page when defined',
        'View::Pages::Custom::ImplementPage',
        http_status: :internal_server_error

      include_examples 'should respond with the page when defined',
        'View::Pages::Resources::ImplementPage',
        http_status: :internal_server_error

      include_examples 'should respond with the page when defined',
        'Librum::Core::View::Pages::Resources::ImplementPage',
        http_status:  :internal_server_error,
        lazy_require: true
    end

    describe 'with a failing result with a NotFound error' do
      let(:error) do
        Cuprum::Collections::Errors::NotFound.new(
          attribute_name:  'slug',
          attribute_value: 'imp-iv',
          collection_name: 'rockets'
        )
      end
      let(:result) { Cuprum::Result.new(error: error) }
      let(:expected_flash) do
        {
          warning: {
            icon:    'exclamation-triangle',
            message: 'Rocket not found with key "imp-iv"'
          }
        }
      end

      it 'should return a redirect response' do
        expect(response)
          .to be_a Cuprum::Rails::Responses::Html::RedirectResponse
      end

      it { expect(response.flash).to be == expected_flash }

      it { expect(response.path).to be == resource.routes.index_path }

      it { expect(response.status).to be 302 } # rubocop:disable RSpec/Rails/HaveHttpStatus
    end

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
