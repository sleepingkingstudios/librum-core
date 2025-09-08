# frozen_string_literal: true

require 'sleeping_king_studios/tools/toolbox/mixin'

require 'cuprum/rails/responders/html/rendering'
require 'librum/components'
require 'plumbum'

module Librum::Core::Responders::Html
  # Implements generating HTML response objects for view components.
  module Rendering # rubocop:disable Metrics/ModuleLength
    extend SleepingKingStudios::Tools::Toolbox::Mixin

    include Plumbum::Consumer
    include Cuprum::Rails::Responders::Html::Rendering

    # Class methods to extend when including Rendering in a module.
    module ClassMethods
      # Helper object for finding view components for a controller view.
      def find_view
        @find_view ||= Librum::Core::Responders::Html::FindView.new(
          application: Rails.application,
          libraries:   Rails::Engine.subclasses
        )
      end
    end

    # Exception raised when trying to render a component without a definition.
    class ComponentNotFoundError < StandardError; end

    WHITESPACE_PATTERN = /\s+/
    private_constant :WHITESPACE_PATTERN

    provider Librum::Components.provider

    dependency :components, optional: true

    # Finds the requested shared component.
    #
    # @param name [String, Symbol] the name of the requested component.
    # @param default [ViewComponent::Base] if no matching component is found,
    #   returns this value. Defaults to nil.
    #
    # @return [ViewComponent::Base, nil] the matching component, or the default
    #   value or nil if no matching component is found.
    def find_component_class(name, default: nil)
      return default unless components.is_a?(Module)

      name = convert_to_class_name(name)

      find_scoped_component_class(name) || default
    end

    # Creates a Response based on the given result and options.
    #
    # @param result [Cuprum::Result] the result to render.
    # @param action [String] the name of the action to render. Defaults to the
    #   current action name.
    # @param flash [Hash] the flash messages to set.
    # @param layout [String, nil] the layout to render.
    # @param status [Integer, Symbol] the HTTP status of the response.
    #
    # @return [Responses::Html::RenderComponentResponse] the response.
    def render_component( # rubocop:disable Metrics/MethodLength
      result,
      action: nil,
      flash:  {},
      layout: nil,
      status: :ok
    )
      action  ||= action_name
      component =
        find_component(action_name: action, controller_name:, result:)

      if component
        return build_response(component, flash:, layout:, result:, status:)
      end

      handle_missing_component(
        action_name:     action,
        controller_name:,
        flash:,
        layout:,
        result:,
        status:
      )
    end

    private

    def build_component(component_class, result, **)
      parameters = component_class.instance_method(:initialize).parameters

      if parameters.select { |type, _| type == :req }.first == %i[req result] # rubocop:disable Style/HashSlice
        component_class.new(result, resource:, **)
      else
        component_class.new(result:, resource:, **)
      end
    end

    def build_response(component, layout:, result:, **)
      layout = empty_layout if layout.nil? && component_is_layout?(component)

      Librum::Core::Responses::Html::RenderComponentResponse.new(
        component,
        assigns: extract_assigns(result),
        layout:,
        **
      )
    end

    def component_is_layout?(component)
      return false unless component.respond_to?(:is_layout?)

      component.is_layout?
    end

    def convert_to_class_name(value)
      value
        .to_s
        .titleize
        .gsub('/', '::')
        .gsub(WHITESPACE_PATTERN, '')
    end

    def empty_layout
      'application'
    end

    def extract_assigns(result)
      return {} unless result.respond_to?(:to_cuprum_result)

      { 'result' => result }
        .merge(extract_assigns_from_metadata(result))
        .merge(extract_assigns_from_value(result))
    end

    def extract_assigns_from_metadata(result)
      return {} unless result.respond_to?(:metadata)

      result.metadata&.stringify_keys || {}
    end

    def extract_assigns_from_value(result)
      return {} unless result.value.is_a?(Hash)

      result
        .value
        .each
        .select { |key, _| key.to_s.start_with?('_') }
        .to_h { |(key, assign)| [key.to_s.sub(/\A_/, ''), assign] }
    end

    def find_component(action_name:, controller_name:, result:)
      return result if result.is_a?(ViewComponent::Base)

      return result.value if result.value.is_a?(ViewComponent::Base)

      component_class = self.class.find_view.call(
        action:     action_name,
        controller: controller_name
      )

      return build_component(component_class, result) if component_class

      nil
    end

    def find_scoped_component_class(name, scope: nil)
      name
        .split('::')
        .tap { |ary| ary.unshift(scope) if scope }
        .reduce(components) do |namespace, segment|
          break unless namespace.const_defined?(segment)

          namespace.const_get(segment)
        end
    end

    def handle_missing_component(action_name:, controller_name:, **)
      raise ComponentNotFoundError,
        'unable to find matching component for action: ' \
        "#{action_name.inspect} and controller: #{controller_name.inspect}"
    end
  end
end
