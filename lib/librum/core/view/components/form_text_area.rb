# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders a form text area.
  class FormTextArea < ViewComponent::Base
    include Librum::Core::View::Options
    include Librum::Core::View::FormErrors

    # @param id [String] a unique identifier for the input.
    # @param name [String] the scoped name of the form input.
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
    # @option options rows [Integer] the height of the textarea, in rows of
    #   text.
    def initialize(name, id: nil, value: nil, **options)
      super(**options)

      @id    = id
      @name  = name
      @value = value
    end

    option :disabled?, boolean: true

    option :placeholder

    option :rows

    # @return [String] a unique identifier for the input.
    attr_reader :id

    # @return [String] the scoped name of the form input.
    attr_reader :name

    # @return [Hash] additional options for the input.
    attr_reader :options

    # @return [String] the value to place in the input.
    attr_reader :value

    private

    def attributes # rubocop:disable Metrics/AbcSize
      hsh = {
        class: class_names,
        name:  name
      }

      hsh[:id]          = id          if id.present?
      hsh[:placeholder] = placeholder if placeholder.present?
      hsh[:rows]        = rows.to_s   if rows
      hsh[:disabled]    = true        if disabled?

      hsh
    end

    def class_names
      ary = %w[textarea]

      ary << 'is-danger' if matching_errors.any?

      ary.join(' ')
    end
  end
end
