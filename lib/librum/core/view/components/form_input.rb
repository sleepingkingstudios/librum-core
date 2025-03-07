# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders a basic form input.
  class FormInput < ViewComponent::Base
    include Librum::Core::View::FormErrors

    # @param id [String] a unique identifier for the input.
    # @param name [String] the scoped name of the form input.
    # @param type [String] the input type.
    # @param value [String] the value to place in the input, if any.
    # @param options [Hash] additional options for the input.
    #
    # @option options disabled [Boolean] if true, renders the input as disabled.
    # @option options error_key [String] the key used to identify matching
    #   errors. Defaults to the input name.
    # @option options errors [Stannum::Errors, Array<String>] the form errors to
    #   apply.
    # @option options placeholder [String] the placeholder value to display in
    #   an empty input.
    def initialize(name, id: nil, type: 'text', value: nil, **)
      super(**)

      @id    = id
      @name  = name
      @type  = type
      @value = value
    end

    # @return [String] a unique identifier for the input.
    attr_reader :id

    # @return [String] the scoped name of the form input.
    attr_reader :name

    # @return [Hash] additional options for the input.
    attr_reader :options

    # @return [String] the input type.
    attr_reader :type

    # @return [String] the value to place in the input.
    attr_reader :value

    # @return [String] the rendered component.
    def call
      tag.input(**attributes)
    end

    # @return [Boolean] if true, renders the input as disabled.
    def disabled?
      !!@options[:disabled]
    end

    # @return [String] the placeholder value to display in an empty input.
    def placeholder
      @options[:placeholder]
    end

    private

    def attributes
      hsh = id.present? ? { id: id } : {}

      hsh[:disabled] = true if disabled?

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
