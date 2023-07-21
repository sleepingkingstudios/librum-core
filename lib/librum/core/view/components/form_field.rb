# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders a form field wrapping a basic input or given contents.
  class FormField < ViewComponent::Base
    include Librum::Core::View::DataMatching
    include Librum::Core::View::ErrorMatching

    # @param data [#[]] the data for the form.
    # @param errors [Stannum::Errors, Array<String>] the form errors to apply.
    # @param icon [String] the icon to display as part of the field.
    # @param label [String] the label to display. Defaults to the last component
    #   of the name.
    # @param name [String] the scoped name of the form input.
    # @param placeholder [String] the placeholder value to display in an empty
    #   input.
    # @param type [String] the input type.
    # @param value [String] the value to place in the input, if any.
    def initialize( # rubocop:disable Metrics/ParameterLists
      name,
      data:        nil,
      errors:      nil,
      icon:        nil,
      label:       nil,
      placeholder: nil,
      type:        'text',
      value:       nil
    )
      super()

      @data        = data
      @errors      = errors
      @icon        = icon
      @label       = label
      @name        = name
      @placeholder = placeholder
      @type        = type
      @value       = value
    end

    # @return [#[]] the data for the form.
    attr_reader :data

    # @return [Stannum::Errors, Array<String>] the form errors to apply.
    attr_reader :errors

    # @return [String] the icon to display as part of the field.
    attr_reader :icon

    # @return [String] the scoped name of the form input.
    attr_reader :name

    # @return [String] the placeholder value to display in an empty input.
    attr_reader :placeholder

    # @return [String] the input type.
    attr_reader :type

    # @return [String] the generated input ID.
    def id
      name
        .gsub(']', '')
        .split(/[.\[]/)
        .map(&:underscore)
        .join('_')
    end

    # @return [View::Components::FormInput] the default input component.
    def input
      Librum::Core::View::Components::FormInput.new(
        name,
        errors:      matching_errors,
        id:          id,
        placeholder: placeholder,
        type:        type,
        value:       value
      )
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

    # @return [String] the value to place in the input.
    def value
      return @value if @value

      matching_data
    end

    private

    def control_class_names
      names = %w[control]

      names << 'has-icons-left' if icon

      names << 'has-icons-right' if matching_errors.any?

      names.join(' ')
    end
  end
end
