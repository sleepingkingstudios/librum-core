# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders a form field wrapping a basic input or given contents.
  class FormField < ViewComponent::Base
    include Librum::Core::View::DataMatching
    include Librum::Core::View::FormErrors

    # @param data [#[]] the data for the form.
    # @param label [String] the label to display. Defaults to the last component
    #   of the name.
    # @param name [String] the scoped name of the form input.
    # @param type [String] the input type.
    # @param value [String] the value to place in the input, if any.
    # @param options [Hash] additional options for the field or input.
    #
    # @option options error_key [String] the key used to identify matching
    #   errors. Defaults to the input name.
    # @option options [Stannum::Errors, Array<String>] the form errors to apply.
    # @option options icon [String] the icon to display as part of the field.
    # @option options items [Array] the options or option groups to display for
    #   a select input.
    # @option options placeholder [String] the placeholder value to display in
    #   an empty input.
    def initialize( # rubocop:disable Metrics/ParameterLists
      name,
      data:  nil,
      label: nil,
      type:  'text',
      value: nil,
      **options
    )
      super(**options)

      @data    = data
      @label   = label
      @name    = name
      @type    = type
      @value   = value
    end

    # @return [#[]] the data for the form.
    attr_reader :data

    # @return [String] the scoped name of the form input.
    attr_reader :name

    # @return [Hash] additional options for the field or input.
    attr_reader :options

    # @return [String] the input type.
    attr_reader :type

    # @return [String] the icon to display as part of the field.
    def icon
      @options[:icon]
    end

    # @return [String] the generated input ID.
    def id
      name
        .gsub(']', '')
        .split(/[.\[]/)
        .map(&:underscore)
        .join('_')
    end

    # @return [Array] the options or option groups to display for a select
    #   input.
    def items
      @options[:items]
    end

    # @return [String] the label text.
    def label
      @label ||=
        name
        .gsub(']', '')
        .split(/[.\[]/)
        .last
        .titleize
    end

    # @return [String] the placeholder value to display in an empty input.
    def placeholder
      @options[:placeholder]
    end

    # @return [String] the value to place in the input.
    def value
      return @value if @value

      matching_data
    end

    private

    def build_form_input
      Librum::Core::View::Components::FormInput.new(
        name,
        errors:      matching_errors,
        id:          id,
        placeholder: placeholder,
        type:        type,
        value:       value,
        **input_options
      )
    end

    def build_input
      case type
      when :select
        build_select_input
      else
        build_form_input
      end
    end

    def build_select_input
      Librum::Core::View::Components::FormSelect.new(
        name,
        errors: matching_errors,
        id:     id,
        items:  items,
        value:  value,
        **input_options
      )
    end

    def control_class_names
      names = %w[control]

      names << 'has-icons-left' if icon

      names << 'has-icons-right' if matching_errors.any?

      names.join(' ')
    end

    def input_options
      options.except(:icon, :items, :placeholder)
    end

    def render_input
      render(build_input)
    end
  end
end
