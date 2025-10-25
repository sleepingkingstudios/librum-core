# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/provider'

module Librum::Core::RSpec::Deferred::Responses
  # Deferred examples for validating HTML responses.
  module HtmlResponseExamples
    include RSpec::SleepingKingStudios::Deferred::Provider

    # Asserts that the response renders the given view component.
    #
    # @param component_name [Class, String, Proc] the expected component or name
    #   of the expected component class.
    # @param assigns [Hash, Proc] the expected values assigned to the component.
    #   Defaults to assigning the current result, if any.
    # @param flash [Hash, Proc] the flash messages rendered along with the
    #   component.
    # @param http_status [Integer, Symbol, nil] the expected http status for the
    #   response. Defaults to 200 OK.
    # @param layout [String] the expected layout for the response. Defaults to
    #   "application" if the component is itself a layout, or nil for all other
    #   components.
    # @param result [Cuprum::Rails::Result] the action result.
    # @param resource [Cuprum::Rails::Resource] the resource for the rendering
    #   controller.
    #
    # The following methods must be defined in the example group:
    #
    # - #response: The response being tested.
    deferred_examples 'should render component' do |
      component_name = nil,
      **component_options
    |
      include RSpec::SleepingKingStudios::Deferred::Dependencies

      depends_on :response, 'the response being tested'

      let(:configured_component) do
        component = component_name
        component = instance_exec(&component)   if component.is_a?(Proc)
        component = Object.const_get(component) if component.is_a?(String)

        be_a(component)
      end
      let(:configured_assigns) do
        assigns = component_options.fetch(:assigns, {})
        assigns = instance_exec(&assigns) if assigns.is_a?(Proc)

        if defined?(result) && result.is_a?(Cuprum::Result)
          assigns = assigns.merge('result' => result)
        end

        assigns
      end
      let(:configured_flash) do
        flash = component_options.fetch(:flash, {})
        flash = instance_exec(&flash) if flash.is_a?(Proc)
        flash
      end
      let(:configured_layout) do
        layout = component_options.fetch(:layout) do
          next is_layout? ? 'application' : nil
        end
        layout = instance_exec(&layout) if layout.is_a?(Proc)
        layout
      end
      let(:configured_resource) do
        resource = component_options.fetch(:resource) do
          respond_to?(:resource) ? self.resource : nil
        end
        resource = instance_exec(&resource) if resource.is_a?(Proc)
        resource
      end
      let(:configured_result) do
        result = component_options.fetch(:result) do
          respond_to?(:result) ? self.result : nil
        end
        result = instance_exec(&result) if result.is_a?(Proc)
        result
      end
      let(:configured_status) do
        status = component_options.fetch(:http_status, :ok)
        status = instance_exec(&status) if status.is_a?(Proc)
        status
      end
      let(:expected_assigns) do
        defined?(super()) ? super() : configured_assigns
      end

      define_method(:is_layout?) do # rubocop:disable Naming/PredicatePrefix
        return false unless response.component.respond_to?(:is_layout?)

        response.component.is_layout?
      end

      define_method(:safe_match) do |expected|
        next eq(expected) if expected.is_a?(Integer) || expected.is_a?(Symbol)

        match(expected)
      end

      it 'should respond with a rendered component' do
        expect(response)
          .to be_a Librum::Core::Responses::Html::RenderComponentResponse
      end

      it { expect(response.component).to match(configured_component) }

      it { expect(response.assigns).to match(expected_assigns) }

      it { expect(response.flash).to match(configured_flash) }

      it { expect(response.layout).to safe_match(configured_layout) }

      it { expect(response.status).to safe_match(configured_status) }

      it 'should set the component resource' do
        next unless response.component.respond_to?(:resource)

        expect(response.component.resource).to match(configured_resource)
      end

      it 'should set the component result' do
        next unless response.component.respond_to?(:result)

        expect(response.component.result).to match(configured_result)
      end
    end
  end
end
