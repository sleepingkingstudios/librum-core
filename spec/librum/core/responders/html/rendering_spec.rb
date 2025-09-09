# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/rspec/deferred/responder_examples'
require 'librum/components'

RSpec.describe Librum::Core::Responders::Html::Rendering do
  include Cuprum::Rails::RSpec::Deferred::ResponderExamples
  include Librum::Core::RSpec::Examples::ResponderExamples

  subject(:responder) do
    described_class.new(action_name:, controller_name:, resource:)
  end

  deferred_examples 'should render the matching component' do |**page_options|
    context 'when there is not a matching component' do
      let(:expected_action) do
        next super() if defined?(super())

        responder.action_name
      end
      let(:error_message) do
        'unable to find matching component for action: ' \
          "#{expected_action.inspect} and controller: " \
          "#{controller_name.inspect}"
      end

      it 'should raise an exception' do
        expect { response }.to raise_error(
          described_class::ComponentNotFoundError,
          error_message
        )
      end
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
          .with(action: expected_action, controller: controller_name)
          .and_return(Spec::ExampleComponent)
      end

      include_deferred 'should render component',
        'Spec::ExampleComponent',
        **page_options

      context 'when the component accepts a result argument' do
        before(:example) do
          Spec::ExampleComponent.class_eval do
            def initialize(result, *, **)
              @result = result

              super(*, **)
            end

            attr_reader :result
          end
        end

        it { expect(response.component.result).to be result }
      end

      context 'when the component accepts a result keyword' do
        before(:example) do
          Spec::ExampleComponent.class_eval do
            def initialize(*, result:, **)
              @result = result

              super(*, **)
            end

            attr_reader :result
          end
        end

        it { expect(response.component.result).to be result }
      end
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
          .with(action: expected_action, controller: controller_name)
          .and_return(Spec::ExampleComponent)
      end

      include_deferred 'should render component',
        'Spec::ExampleComponent',
        **page_options

      context 'when the component accepts a result argument' do
        before(:example) do
          Spec::ExampleComponent.class_eval do
            def initialize(result, *, **)
              @result = result

              super(*, **)
            end

            attr_reader :result
          end
        end

        it { expect(response.component.result).to be result }
      end

      context 'when the component accepts a result keyword' do
        before(:example) do
          Spec::ExampleComponent.class_eval do
            def initialize(*, result:, **)
              @result = result

              super(*, **)
            end

            attr_reader :result
          end
        end

        it { expect(response.component.result).to be result }
      end
    end
  end

  let(:described_class) { Spec::ExampleResponder }
  let(:action_name)     { :publish }
  let(:controller_name) { 'books' }
  let(:resource)        { Cuprum::Rails::Resource.new(name: 'books') }

  example_class 'Spec::ExampleResponder',
    Struct.new(:action_name, :controller_name, :resource) \
  do |klass|
    klass.include Librum::Core::Responders::Html::Rendering # rubocop:disable RSpec/DescribedClass
  end

  describe '::ComponentNotFoundError' do
    include_examples 'should define constant',
      :ComponentNotFoundError,
      -> { be_a(Module).and be < StandardError }
  end

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
        # :nocov:
        if described_class.instance_variable_defined?(:@find_view)
          described_class.remove_instance_variable(:@find_view)
        end
        # :nocov:

        example.call
      ensure
        described_class.remove_instance_variable(:@find_view)
      end

      it { expect(service.libraries).to be == expected_engines }
    end
  end

  describe '#build_view' do
    let(:resource) { Cuprum::Rails::Resource.new(name: 'books') }
    let(:result)   { Cuprum::Rails::Result.new }
    let(:options)  { {} }
    let(:component) do
      responder.build_view(component_class, resource:, result:, **options)
    end

    it 'should define the method' do
      expect(responder)
        .to respond_to(:build_view)
        .with(1).argument
        .and_keywords(:result, :resource)
        .and_any_keywords
    end

    define_method :tools do
      SleepingKingStudios::Tools::Toolbelt.instance
    end

    describe 'with nil' do
      let(:component_class) { nil }
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.presence',
          as: 'component_class'
        )
      end

      it 'should raise an exception' do
        expect { responder.build_view(component_class, resource:, result:) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an Object' do
      let(:component_class) { Object.new.freeze }
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.class',
          as: 'component_class'
        )
      end

      it 'should raise an exception' do
        expect { responder.build_view(component_class, resource:, result:) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with a legacy page component' do
      let(:component_class) { Spec::LegacyPage }

      example_class 'Spec::LegacyPage', ViewComponent::Base do |klass|
        klass.define_method(:initialize) do |result, resource:, **options|
          @result   = result
          @resource = resource
          @options  = options
        end

        klass.attr_reader :options

        klass.attr_reader :resource

        klass.attr_reader :result
      end

      it { expect(component).to be_a component_class }

      it { expect(component.resource).to be resource }

      it { expect(component.result).to be result }

      it { expect(component.options).to be == {} }

      describe 'with options' do
        let(:options) { super().merge(key: 'value') }

        it { expect(component.options).to be == options }
      end
    end

    describe 'with a view' do
      let(:component_class) { Spec::ExampleView }

      example_class 'Spec::ExampleView', Librum::Components::View do |klass| # rubocop:disable Style/SymbolProc
        klass.allow_extra_options
      end

      it { expect(component).to be_a component_class }

      it { expect(component.resource).to be resource }

      it { expect(component.result).to be result }

      it { expect(component.options).to be == {} }

      describe 'with options' do
        let(:options) { super().merge(key: 'value') }

        it { expect(component.options).to be == options }
      end
    end
  end

  describe '#components' do
    include_examples 'should define reader', :components, nil

    wrap_deferred 'when the responder is provided components' do
      let(:expected) do
        Librum::Components.provider.get(:components)
      end

      it { expect(responder.components).to be expected }
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

    describe 'with action: a String' do
      let(:options)         { super().merge(action: 'unpublish') }
      let(:expected_action) { 'unpublish' }

      include_deferred 'should render the matching component with options'
    end

    describe 'with action: a Symbol' do
      let(:options)         { super().merge(action: :unpublish) }
      let(:expected_action) { :unpublish }

      include_deferred 'should render the matching component with options'
    end

    describe 'with a result with metadata: nil' do
      let(:result) { Cuprum::Rails::Result.new(metadata: nil) }

      include_deferred 'should render the matching component with options'
    end

    describe 'with a result with metadata' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:value) do
        {
          'book' => {
            title:  'Gideon the Ninth',
            author: 'Tammsyn Muir'
          }
        }
      end
      let(:metadata) do
        {
          page:    { title: 'The Locked Tomb Series' },
          session: { token: '12345' }
        }
      end
      let(:result) do
        Cuprum::Rails::Result.new(value: value, metadata: metadata)
      end
      let(:expected_assigns) do
        {
          'page'    => { title: 'The Locked Tomb Series' },
          'result'  => result,
          'session' => { token: '12345' }
        }
      end

      include_deferred 'should render the matching component with options'
    end

    describe 'with a result with value: a Hash with metadata' do
      let(:value) do
        {
          'book'     => {
            title:  'Gideon the Ninth',
            author: 'Tammsyn Muir'
          },
          '_page'    => { title: 'The Locked Tomb Series' },
          '_session' => { token: '12345' }
        }
      end
      let(:result) { Cuprum::Result.new(value: value) }
      let(:expected_assigns) do
        {
          'page'    => { title: 'The Locked Tomb Series' },
          'result'  => result,
          'session' => { token: '12345' }
        }
      end

      include_deferred 'should render the matching component with options'
    end

    describe 'with result: a ViewComponent' do
      let(:result) { Spec::CustomComponent.new }

      example_class 'Spec::CustomComponent', ViewComponent::Base

      include_deferred 'should render component with options',
        'Spec::CustomComponent'
    end

    describe 'with a result with value: a ViewComponent' do
      let(:component) { Spec::CustomComponent.new }
      let(:result)    { Cuprum::Result.new(value: component) }

      example_class 'Spec::CustomComponent', ViewComponent::Base

      include_deferred 'should render component with options',
        'Spec::CustomComponent'
    end
  end
end
