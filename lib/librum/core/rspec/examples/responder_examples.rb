# frozen_string_literal: true

require 'rspec/sleeping_king_studios/contract'

module Librum::Core::RSpec::Examples
  # Deferred examples for testing responders.
  module ResponderExamples
    include RSpec::SleepingKingStudios::Deferred::Provider

    UNDEFINED = Object.new.freeze
    private_constant :UNDEFINED

    deferred_context 'when the responder is provided components' do
      example_constant 'Spec::Components' do
        Module.new
      end

      before(:example) do
        stub_provider(
          Librum::Components.provider,
          :components,
          Spec::Components
        )
      end
    end

    deferred_context 'when the shared component is defined' do |component_name|
      let(:components) { Librum::Components.provider.get(:components) }
      let(:component_class) do
        next super() if defined?(super())

        Class.new(ViewComponent::Base)
      end

      before(:example) do
        *path, name = component_name.split('::')
        namespace   = path.reduce(components) do |namespace, segment|
          unless namespace.const_defined?(segment)
            namespace.const_set(segment, Module.new)
          end

          namespace.const_get(segment)
        end

        namespace.const_set(name, component_class)
      end
    end

    deferred_examples 'should render component' do |
      component_name = nil,
      **component_options
    |
      let(:expected_component) do
        next super() if defined?(super())

        be_a Object.const_get(component_name)
      end
      let(:expected_assigns) do
        next super() if defined?(super())

        result.is_a?(Cuprum::Result) ? { 'result' => result } : {}
      end
      let(:expected_http_status) do
        next super() if defined?(super())

        component_options.fetch(:http_status, :ok)
      end
      let(:expected_flash) do
        next super() if defined?(super())

        next {} unless component_options.key?(:flash)

        flash = component_options[:flash]
        flash = instance_exec(&flash) if flash.is_a?(Proc)

        flash
      end
      let(:expected_layout) do
        next super() if defined?(super())

        unless component_options.key?(:layout)
          next is_layout? ? 'application' : nil
        end

        layout = component_options[:layout]
        layout = instance_exec(&layout) if layout.is_a?(Proc)

        layout
      end

      define_method(:is_layout?) do # rubocop:disable Naming/PredicatePrefix
        return false unless response.component.respond_to?(:is_layout?)

        response.component.is_layout?
      end

      define_method(:safe_match) do |expected|
        next eq(expected) if expected.is_a?(Symbol)

        match(expected)
      end

      it 'should respond with a rendered component' do
        expect(response)
          .to be_a Librum::Core::Responses::Html::RenderComponentResponse
      end

      it { expect(response.component).to match(expected_component) }

      it { expect(response.assigns).to match(expected_assigns) }

      it { expect(response.flash).to match(expected_flash) }

      it { expect(response.layout).to safe_match(expected_layout) }

      it { expect(response.status).to safe_match(expected_http_status) }
    end

    deferred_examples 'should render component with options' do |component_name|
      wrap_deferred 'should render component', component_name

      describe 'with flash: value' do
        let(:flash) do
          {
            alert:  'Reactor temperature critical',
            notice: 'Initializing activation sequence'
          }
        end
        let(:options) { super().merge(flash:) }

        include_deferred 'should render component',
          component_name,
          flash: -> { flash }
      end

      describe 'with layout: value' do
        let(:options) { super().merge(layout: :custom) }

        include_deferred 'should render component',
          component_name,
          layout: :custom
      end

      describe 'with status: value' do
        let(:options) { super().merge(status: :created) }

        include_deferred 'should render component',
          component_name,
          http_status: :created
      end
    end

    deferred_examples 'should render the missing page' do |**page_options|
      context 'when the missing page component is not defined' do
        include_deferred 'should render component',
          'Librum::Core::View::Pages::MissingPage',
          **page_options,
          http_status: :internal_server_error
      end

      context 'when the missing page is defined' do
        include_deferred 'when the responder is provided components'
        include_deferred 'when the shared component is defined',
          'Views::MissingView'

        include_deferred 'should render component',
          'Spec::Components::Views::MissingView',
          **page_options,
          http_status: :internal_server_error
      end
    end
  end
end
