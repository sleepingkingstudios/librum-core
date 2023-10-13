# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders a formatted data field.
  class DataField < ViewComponent::Base
    extend Forwardable

    # Data object representing configuration for a data field.
    class FieldDefinition
      include Librum::Core::View::Options
      include Librum::Core::View::ClassName

      # @param key [String] the data key corresponding to the field contents.
      # @param type [Symbol] the type of field.
      # @param value [Proc, ViewComponent::Base] the custom field value.
      # @param options [Hash] additional options for the data field.
      #
      # @option options class_name [String, Array<String>] additional CSS class
      #   names for the field.
      # @option options color [String] the color of the rendered field.
      # @option options default [String, Proc] the default value for the field.
      # @option options icon [String] the name of the icon, if any, to display.
      # @option options label [String] the label for the field. Defaults to the
      #   key.
      def initialize(
        key:,
        type:    :text,
        value:   nil,
        **options
      )
        super(**options)

        @key   = key
        @type  = type
        @value = value
      end

      option :color

      option :default

      option :icon

      option :label, default: -> { key.titleize }

      # @return [String] the data key corresponding to the field contents.
      attr_reader :key

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
      :class_name,
      :color,
      :default,
      :icon,
      :key,
      :label,
      :options,
      :type,
      :value

    # @return [Hash{String=>Object}] the data used to render the field.
    attr_reader :data

    # @return [View::Components::DataField::FieldDefinition] the configuration
    #   object for rendering the field.
    attr_reader :field

    private

    def build_link
      Librum::Core::View::Components::Link.new(
        field_value,
        class_name: class_name,
        color:      color,
        icon:       icon
      )
    end

    def class_names
      return @class_names if @class_names

      @class_names = class_name
      @class_names << "has-text-#{color}" if color
      @class_names
    end

    def default_value
      return @default_value if @default_value

      return @default_value = default.call(data) if default.is_a?(Proc)

      @default_value = default
    end

    def field_value
      return @field_value if @field_value

      return @field_value = value.call(data) if value.is_a?(Proc)

      return @field_value = value if value.is_a?(ViewComponent::Base)

      @field_value = data[key]
    end

    def render_boolean
      icon  = self.icon  || (field_value ? 'check'   : 'xmark')
      color = self.color || (field_value ? 'success' : 'danger')

      render(
        Librum::Core::View::Components::Icon.new(
          class_name: class_name,
          color:      color,
          icon:       icon
        )
      )
    end

    def render_default
      return render(default_value) if default_value.is_a?(ViewComponent::Base)

      default_value
    end

    def render_icon?
      icon.present?
    end

    def render_link
      render(build_link)
    end

    def render_value
      return render_default if field_value.blank? && default.present?

      return render(field_value) if field_value.is_a?(ViewComponent::Base)

      return render_wrapper if class_names.present?

      field_value
    end

    def render_wrapper
      tag.span(class: class_names) { field_value }
    end
  end
end
