# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders a basic form input.
  class FormInput < ViewComponent::Base
    include Librum::Core::View::ErrorMatching

    # @param errors [Stannum::Errors, Array<String>] the form errors to apply.
    # @param id [String] a unique identifier for the input.
    # @param name [String] the scoped name of the form input.
    # @param placeholder [String] the placeholder value to display in an empty
    #   input.
    # @param type [String] the input type.
    # @param value [String] the value to place in the input, if any.
    def initialize( # rubocop:disable Metrics/ParameterLists
      name,
      errors:      nil,
      id:          nil,
      placeholder: nil,
      type:        'text',
      value:       nil
    )
      super()

      @errors      = errors
      @id          = id
      @name        = name
      @placeholder = placeholder
      @type        = type
      @value       = value
    end

    # @return [Stannum::Errors, Array<String>] the form errors to apply.
    attr_reader :errors

    # @return [String] a unique identifier for the input.
    attr_reader :id

    # @return [String] the scoped name of the form input.
    attr_reader :name

    # @return [String] the placeholder value to display in an empty input.
    attr_reader :placeholder

    # @return [String] the input type.
    attr_reader :type

    # @return [String] the value to place in the input.
    attr_reader :value

    # @return [String] the rendered component.
    def call
      tag.input(**attributes)
    end

    private

    def attributes
      hsh = id.present? ? { id: id } : {}

      hsh.merge(
        name:        name,
        class:       class_names,
        placeholder: placeholder,
        type:        type,
        value:       value
      )
    end

    def class_names
      names = %w[input]

      names << 'is-danger' if matching_errors.any?

      names.join(' ')
    end
  end
end
