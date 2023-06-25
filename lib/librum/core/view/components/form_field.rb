# frozen_string_literal: true

require 'librum/core/view/components'
require 'librum/core/view/components/form_input'
require 'librum/core/view/error_matching'

module Librum::Core::View::Components
  # Renders a form field wrapping a basic input or given contents.
  class FormField < ViewComponent::Base
    include Librum::Core::View::ErrorMatching

    # @param errors [Stannum::Errors, Array<String>] the form errors to apply.
    # @param icon [String] the icon to display as part of the field.
    # @param name [String] the scoped name of the form input.
    # @param type [String] the input type.
    def initialize(name, errors: nil, icon: nil, type: 'text')
      super()

      @errors = errors
      @icon   = icon
      @name   = name
      @type   = type
    end

    # @return [Stannum::Errors, Array<String>] the form errors to apply.
    attr_reader :errors

    # @return [String] the icon to display as part of the field.
    attr_reader :icon

    # @return [String] the scoped name of the form input.
    attr_reader :name

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
        errors: matching_errors,
        id:     id,
        type:   type
      )
    end

    # @return [String] the label text.
    def label
      name
        .gsub(']', '')
        .split(/[.\[]/)
        .join(' ')
        .titleize
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
