# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders a form select option.
  class FormSelect::Option < ViewComponent::Base
    # @param label [String] the label to display.
    # @param options [Hash] additional options for the form select option.
    # @param value [String] the value for the option.
    #
    # @option options disabled [Boolean] if true, renders the option as
    #   disabled.
    # @option options selected [Boolean] if true, the option is selected when
    #   the page renders.
    def initialize(label:, value:, **options)
      super()

      @label   = label
      @value   = value
      @options = options
    end

    # @return [String] the label to display.
    attr_reader :label

    # @return [Hash] additional options for the form select option.
    attr_reader :options

    # @return [String] the value for the option.
    attr_reader :value

    # @return [String] the rendered component.
    def call
      content_tag('option', **attributes) { label }
    end

    # @return [Boolean] if true, renders the option as disabled.
    def disabled?
      !!@options[:disabled]
    end

    # @return [Boolean] if true, the option is selected when the page renders.
    def selected?
      !!@options[:selected]
    end

    private

    def attributes
      hsh = { value: value }

      hsh[:disabled] = true if disabled?
      hsh[:selected] = true if selected?

      hsh
    end
  end
end
