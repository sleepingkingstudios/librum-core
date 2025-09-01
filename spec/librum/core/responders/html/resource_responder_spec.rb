# frozen_string_literal: true

require 'rails_helper'

require 'stannum/errors'

require 'cuprum/collections'
require 'cuprum/rails/rspec/deferred/responder_examples'

require 'support/models/rocket'

RSpec.describe Librum::Core::Responders::Html::ResourceResponder do
  include Cuprum::Rails::RSpec::Deferred::ResponderExamples
  include Librum::Core::RSpec::Examples::ResponderExamples

  subject(:responder) { described_class.new(**constructor_options) }

  deferred_examples 'should render the matching component' do |**page_options|
    context 'when there is not a matching component' do
      include_deferred 'should render the missing page', **page_options
    end

    context 'when there is a matching page component' do
      let(:expected_action) do
        next super() if defined?(super())

        responder.action_name
      end

      example_class 'Spec::ExampleComponent', ViewComponent::Base do |klass|
        klass.define_method(:is_layout?) { true }
      end

      before(:example) do
        allow(service)
          .to receive(:call)
          .with(action: expected_action, controller: controller.class.name)
          .and_return(Spec::ExampleComponent)
      end

      include_deferred 'should render component',
        'Spec::ExampleComponent',
        **page_options
    end

    context 'when there is a matching view component' do
      let(:expected_action) do
        next super() if defined?(super())

        responder.action_name
      end

      example_class 'Spec::ExampleComponent', ViewComponent::Base

      before(:example) do
        allow(service)
          .to receive(:call)
          .with(action: expected_action, controller: controller.class.name)
          .and_return(Spec::ExampleComponent)
      end

      include_deferred 'should render component',
        'Spec::ExampleComponent',
        **page_options
    end

    context 'when there is a matching generic resource page' do
      let(:expected_action) do
        next super() if defined?(super())

        responder.action_name
      end

      example_class 'Spec::ResourceComponent', ViewComponent::Base

      before(:example) do
        allow(service)
          .to receive(:call)
          .with(action: expected_action, controller: 'Resources')
          .and_return(Spec::ResourceComponent)
      end

      include_deferred 'should render component',
        'Spec::ResourceComponent',
        **page_options
    end
  end

  let(:member_action) { false }
  let(:constructor_options) do
    {
      action_name:   action_name,
      controller:    controller,
      member_action: member_action,
      request:       request
    }
  end

  include_deferred 'should implement the Responder methods'

  describe '.find_view' do
    let(:service) { described_class.find_view }

    include_examples 'should define class reader', :find_view

    it { expect(service).to be_a Librum::Core::Responders::Html::FindView }

    it { expect(service.application).to be Rails.application }

    it { expect(service.libraries).to be == [] }

    context 'when the application engines define view paths' do
      let(:engines) do
        [
          Object.new.freeze,
          Spec::Engine.new('Example'),
          Spec::Engine.new('WebhooksEngine'),
          Spec::Engine.new('CustomRailtie')
        ]
      end
      let(:expected_engines) do
        engines.select { |engine| engine.respond_to?(:view_path) }
      end

      example_class 'Spec::Engine', Struct.new(:name) do |klass|
        klass.define_method(:view_path) { '' }
      end

      before(:example) do
        allow(Rails::Engine).to receive(:subclasses).and_return(engines)
      end

      around(:example) do |example|
        described_class.remove_instance_variable(:@find_view)

        example.call
      ensure
        described_class.remove_instance_variable(:@find_view)
      end

      it { expect(service.libraries).to be == expected_engines }
    end
  end

  describe '#call' do
    deferred_context 'when initialized with a plural resource' do
      let(:resource_options) { super().merge(name: 'books', singular: false) }
    end

    deferred_context 'when initialized with a singular resource' do
      let(:resource_options) { super().merge(name: 'book', singular: true) }
    end

    let(:result)   { Cuprum::Result.new }
    let(:response) { responder.call(result) }
    let(:service) do
      instance_double(Librum::Core::Responders::Html::FindView, call: nil)
    end

    before(:example) do
      allow(described_class).to receive(:find_view).and_return(service)
    end

    it { expect(responder).to respond_to(:call).with(1).argument }

    include_deferred 'should render the matching component'

    describe 'with a failing result' do
      let(:error)  { Cuprum::Error.new(message: 'Something went wrong') }
      let(:result) { Cuprum::Result.new(error: error) }

      include_deferred 'should render the matching component',
        http_status: :internal_server_error
    end

    describe 'with a failing result with a NotFound error' do
      let(:result) { Cuprum::Result.new(error: error) }

      context 'when the error does not match a resource' do
        let(:error) do
          Cuprum::Collections::Errors::NotFound.new(
            attribute_name:  'slug',
            attribute_value: 'jack_of_hearts',
            collection_name: 'playing_cards',
            primary_key:     false
          )
        end

        include_deferred 'should render the matching component',
          flash:       {
            warning: {
              icon:    'exclamation-triangle',
              message: 'Playing Card not found with key "jack_of_hearts"'
            }
          },
          http_status: :not_found
      end

      context 'when the error matches the resource' do
        let(:error) do
          Cuprum::Collections::Errors::NotFound.new(
            attribute_name:  'id',
            attribute_value: 0,
            collection_name: 'books'
          )
        end

        wrap_deferred 'when initialized with a plural resource' do
          include_deferred 'should redirect to',
            -> { resource.routes.index_path },
            flash: {
              warning: {
                icon:    'exclamation-triangle',
                message: 'Book not found with key "0"'
              }
            }
        end

        wrap_deferred 'when initialized with a singular resource' do
          include_deferred 'should redirect to',
            -> { resource.routes.show_path },
            flash: {
              warning: {
                icon:    'exclamation-triangle',
                message: 'Book not found with key "0"'
              }
            }
        end
      end

      context 'when the error matches the parent resource' do
        let(:publishers_resource) do
          Cuprum::Rails::Resource.new(name: 'publishers')
        end
        let(:authors_resource) do
          Cuprum::Rails::Resource.new(
            name:   'authors',
            parent: publishers_resource
          )
        end
        let(:resource_options) do
          super().merge(parent: authors_resource)
        end
        let(:request) do
          Cuprum::Rails::Request.new(
            action_name:,
            path_params: { publisher_id: 0 }
          )
        end
        let(:error) do
          Cuprum::Collections::Errors::NotFound.new(
            attribute_name:  'id',
            attribute_value: 0,
            collection_name: 'authors'
          )
        end

        include_deferred 'should redirect to',
          lambda {
            authors_resource.routes.with_wildcards(publisher_id: 0).index_path
          },
          flash: {
            warning: {
              icon:    'exclamation-triangle',
              message: 'Author not found with key "0"'
            }
          }
      end

      context 'when the error matches the top-level resource' do
        let(:publishers_resource) do
          Cuprum::Rails::Resource.new(name: 'publishers')
        end
        let(:authors_resource) do
          Cuprum::Rails::Resource.new(
            name:   'authors',
            parent: publishers_resource
          )
        end
        let(:resource_options) do
          super().merge(parent: authors_resource)
        end
        let(:error) do
          Cuprum::Collections::Errors::NotFound.new(
            attribute_name:  'id',
            attribute_value: 0,
            collection_name: 'publishers'
          )
        end

        include_deferred 'should redirect to',
          lambda {
            publishers_resource.routes.index_path
          },
          flash: {
            warning: {
              icon:    'exclamation-triangle',
              message: 'Publisher not found with key "0"'
            }
          }
      end
    end

    describe 'with a passing result' do
      let(:value)  { { ok: true } }
      let(:result) { Cuprum::Result.new(value: value) }

      include_deferred 'should render the matching component'
    end

    context 'with action_name: "create"' do
      let(:action_name) { 'create' }

      describe 'with a failing result' do
        let(:error)  { Cuprum::Error.new(message: 'Something went wrong') }
        let(:result) { Cuprum::Result.new(error: error) }

        include_deferred 'should render the matching component',
          http_status: :internal_server_error
      end

      describe 'with a failing result with a FailedValidation error' do
        let(:error) do
          Cuprum::Collections::Errors::FailedValidation.new(
            entity_class: Hash,
            errors:       Stannum::Errors.new
          )
        end
        let(:result) { Cuprum::Result.new(error: error) }
        let(:expected_action) do
          'new'
        end

        include_deferred 'should render the matching component',
          flash: {
            warning: {
              icon:    'exclamation-triangle',
              message: 'Unable to create Book'
            }
          }
      end

      describe 'with a passing result' do
        let(:record) { Struct.new(:slug).new('gideon-the-ninth') }
        let(:result) { Cuprum::Result.new(value: { 'book' => record }) }

        wrap_deferred 'when initialized with a plural resource' do
          include_deferred 'should redirect to',
            -> { resource.routes.show_path(record.slug) },
            flash: {
              success: {
                icon:    'circle-check',
                message: 'Successfully created Book'
              }
            }
        end

        wrap_deferred 'when initialized with a singular resource' do
          include_deferred 'should redirect to',
            -> { resource.routes.show_path },
            flash: {
              success: {
                icon:    'circle-check',
                message: 'Successfully created Book'
              }
            }
        end
      end
    end

    context 'with action_name: "destroy"' do
      let(:action_name) { 'destroy' }

      describe 'with a failing result' do
        let(:error)  { Cuprum::Error.new(message: 'Something went wrong') }
        let(:result) { Cuprum::Result.new(error: error) }

        include_deferred 'should redirect back',
          flash: {
            warning: {
              icon:    'exclamation-triangle',
              message: 'Unable to destroy Book'
            }
          }
      end

      describe 'with a passing result' do
        let(:result) { Cuprum::Result.new(value: {}) }

        wrap_deferred 'when initialized with a plural resource' do
          include_deferred 'should redirect to',
            -> { resource.routes.index_path },
            flash: {
              danger: {
                icon:    'bomb',
                message: 'Successfully destroyed Book'
              }
            }
        end

        wrap_deferred 'when initialized with a singular resource' do
          include_deferred 'should redirect to',
            -> { resource.routes.show_path },
            flash: {
              danger: {
                icon:    'bomb',
                message: 'Successfully destroyed Book'
              }
            }
        end
      end
    end

    context 'with action_name: "update"' do
      let(:action_name) { 'update' }

      describe 'with a failing result' do
        let(:error)  { Cuprum::Error.new(message: 'Something went wrong') }
        let(:result) { Cuprum::Result.new(error: error) }

        include_deferred 'should render the matching component',
          http_status: :internal_server_error
      end

      describe 'with a failing result with a FailedValidation error' do
        let(:error) do
          Cuprum::Collections::Errors::FailedValidation.new(
            entity_class: Hash,
            errors:       Stannum::Errors.new
          )
        end
        let(:result) { Cuprum::Result.new(error: error) }
        let(:expected_action) do
          'edit'
        end

        include_deferred 'should render the matching component',
          flash: {
            warning: {
              icon:    'exclamation-triangle',
              message: 'Unable to update Book'
            }
          }
      end

      describe 'with a passing result' do
        let(:record) { Struct.new(:slug).new('gideon-the-ninth') }
        let(:result) { Cuprum::Result.new(value: { 'book' => record }) }

        wrap_deferred 'when initialized with a plural resource' do
          include_deferred 'should redirect to',
            -> { resource.routes.show_path(record.slug) },
            flash: {
              success: {
                icon:    'circle-check',
                message: 'Successfully updated Book'
              }
            }
        end

        wrap_deferred 'when initialized with a singular resource' do
          include_deferred 'should redirect to',
            -> { resource.routes.show_path },
            flash: {
              success: {
                icon:    'circle-check',
                message: 'Successfully updated Book'
              }
            }
        end
      end
    end
  end

  describe '#find_component_class' do
    deferred_context 'with default: value' do
      let(:default) { Class.new(ViewComponent::Base) }
      let(:options) { super().merge(default:) }
    end

    let(:name)      { 'custom' }
    let(:options)   { {} }
    let(:component) { responder.find_component_class(name, **options) }

    it 'should define the method' do
      expect(responder)
        .to respond_to(:find_component_class)
        .with(1).argument
        .and_keywords(:default)
    end

    it { expect(component).to be nil }

    wrap_deferred 'with default: value' do
      it { expect(component).to be default }
    end

    wrap_deferred 'when the responder is provided components' do
      it { expect(component).to be nil }

      wrap_deferred 'with default: value' do
        it { expect(component).to be default }
      end

      wrap_deferred 'when the shared component is defined', 'Custom' do
        it { expect(component).to be components::Custom }

        wrap_deferred 'with default: value' do
          it { expect(component).to be components::Custom }
        end
      end
    end

    describe 'with name: a scoped Component name' do
      let(:name) { 'Scoped::Custom' }

      wrap_deferred 'with default: value' do
        it { expect(component).to be default }
      end

      wrap_deferred 'when the responder is provided components' do
        it { expect(component).to be nil }

        wrap_deferred 'with default: value' do
          it { expect(component).to be default }
        end

        wrap_deferred 'when the shared component is defined',
          'Scoped::Custom' \
        do
          it { expect(component).to be components::Scoped::Custom }

          wrap_deferred 'with default: value' do # rubocop:disable RSpec/NestedGroups
            it { expect(component).to be components::Scoped::Custom }
          end
        end
      end
    end
  end

  describe '#format' do
    include_examples 'should define reader', :format, :html
  end

  describe '#render_component' do
    deferred_examples 'should render the matching component with options' do
      include_deferred 'should render the matching component'

      describe 'with flash: value' do
        let(:flash) do
          {
            alert:  'Reactor temperature critical',
            notice: 'Initializing activation sequence'
          }
        end
        let(:options) { super().merge(flash:) }

        include_deferred 'should render the matching component',
          flash: -> { flash }
      end

      describe 'with layout: value' do
        let(:options) { super().merge(layout: :custom) }

        include_deferred 'should render the matching component',
          layout: :custom
      end

      describe 'with status: value' do
        let(:options) { super().merge(status: :created) }

        include_deferred 'should render the matching component',
          http_status: :created
      end
    end

    let(:result)   { Cuprum::Result.new }
    let(:options)  { {} }
    let(:response) { responder.render_component(result, **options) }
    let(:service) do
      instance_double(Librum::Core::Responders::Html::FindView, call: nil)
    end

    before(:example) do
      allow(described_class).to receive(:find_view).and_return(service)
    end

    it 'should define the method' do
      expect(responder)
        .to respond_to(:render_component)
        .with(1).argument
        .and_keywords(:flash, :layout, :status)
    end

    include_deferred 'should render the matching component with options'

    describe 'with action: value' do
      let(:options)         { super().merge(action: 'revert') }
      let(:expected_action) { 'revert' }

      include_deferred 'should render the matching component with options'
    end
  end
end
