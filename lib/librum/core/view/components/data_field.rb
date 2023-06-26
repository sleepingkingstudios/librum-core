# frozen_string_literal: true

require 'librum/core/view/components'
require 'librum/core/view/components/link'

module Librum::Core::View::Components
  # Renders a formatted data field.
  class DataField < ViewComponent::Base
    extend Forwardable

    # Data object representing configuration for a data field.
    class FieldDefinition
      # @param key [String] the data key corresponding to the field contents.
      # @param default [String, Proc] the default value for the field.
      # @param icon [String] the name of the icon, if any, to display.
      # @param label [String] the label for the field. Defaults to the key.
      # @param type [Symbol] the type of field.
      # @param value [Proc, ViewComponent::Base] the custom field value.
      def initialize( # rubocop:disable Metrics/ParameterLists
        key:,
        default: nil,
        icon:    nil,
        label:   nil,
        type:    :text,
        value:   nil
      )
        @key     = key
        @default = default
        @label   = label || key.titleize
        @icon    = icon
        @type    = type
        @value   = value
      end

      # @return [String, Proc] the default value for the field.
      attr_reader :default

      # @return [String] the name of the icon, if any, to display.
      attr_reader :icon

      # @return [String] the data key corresponding to the field contents.
      attr_reader :key

      # @return [String] the label for the field. Defaults to the key.
      attr_reader :label

      # @return [Symbol] the type of field.
      attr_reader :type

      # @return [Proc, ViewComponent::Base] the custom field value.
      attr_reader :value
    end

    # @param data [Hash{String=>Object}] the data used to render the field.
    # @param field [View::Components::DataField::FieldDefinition] the
    #   configuration object for rendering the field.
    def initialize(data:, field:, **)
      super()

      @data  = data
      @field = field.is_a?(Hash) ? FieldDefinition.new(**field) : field
    end

    def_delegators :@field,
      :default,
      :icon,
      :key,
      :type,
      :value

    # @return [Hash{String=>Object}] the data used to render the field.
    attr_reader :data

    # @return [View::Components::DataField::FieldDefinition] the configuration
    #   object for rendering the field.
    attr_reader :field

    private

    def default_value
      return @default_value if @default_value

      return @default_value = default.call(data) if default.is_a?(Proc)

      @default_value = default
    end

    def field_value
      return @field_value if @field_value

      return @field_value = value.call(data) if value.is_a?(Proc)

      return value if value.is_a?(ViewComponent::Base)

      @field_value = data[key]
    end

    def render_contents
      return render_default if field_value.blank? && default.present?

      return render(field_value) if field_value.is_a?(ViewComponent::Base)

      case type
      when :link
        render_link(field_value)
      else
        field_value
      end
    end

    def render_default
      return render(default_value) if default_value.is_a?(ViewComponent::Base)

      default_value
    end

    def render_icon?
      return false unless icon

      return false if field_value.is_a?(ViewComponent::Base)

      type != :link
    end

    def render_link(value)
      render(Librum::Core::View::Components::Link.new(value, icon: icon))
    end
  end
end
