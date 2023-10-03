# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders a form select option group.
  class FormSelect::OptionGroup < ViewComponent::Base
    # @param label [String] the label to display.
    # @param items [Array<Hash>] the options to display.
    # @param options [Hash] additional options for the option group.
    #
    # @option options disabled [Boolean] if true, renders the option group as
    #   disabled.
    def initialize(items:, label:, **options)
      super()

      @items   = items
      @label   = label
      @options = options
    end

    # @return [String] the label to display.
    attr_reader :label

    # @return items [Array<Hash>] the options to display.
    attr_reader :items

    # @return [Hash] additional options for the option group.
    attr_reader :options

    # @return [Boolean] if true, renders the option group as disabled.
    def disabled?
      !!@options[:disabled]
    end

    private

    def attributes
      hsh = { label: label }

      hsh[:disabled] = true if disabled?

      hsh
    end

    def build_item(item)
      if item.key?(:separator)
        build_separator
      else
        Librum::Core::View::Components::FormSelect::Option.new(**item)
      end
    end

    def build_separator
      Librum::Core::View::Components::FormSelect::Option.new(
        disabled: true,
        label:    ' ',
        value:    nil
      )
    end

    def render_item(item)
      render(build_item(item))
    end
  end
end
