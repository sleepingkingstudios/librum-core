# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders a form select input.
  class FormSelect < ViewComponent::Base
    include Librum::Core::View::FormErrors

    # @param items [Array] the options or option groups to display.
    # @param id [String] a unique identifier for the input.
    # @param name [String] the scoped name of the form input.
    # @param value [String] the selected option, if any.
    # @param options [Hash] additional options for displaying the select input.
    #
    # @option options disabled [Boolean] if true, renders the select input as
    #   disabled.
    # @option options error_key [String] the key used to identify matching
    #   errors. Defaults to the input name.
    # @option options errors [Stannum::Errors, Array<String>] the form errors to
    #   apply.
    # @option options include_blank [Boolean] if true, prepends a blank option
    #   with empty value to the select options.
    def initialize(name, items:, id: nil, value: nil, **)
      super(**)

      @name    = name
      @items   = items
      @id      = id
      @value   = value
    end

    # @return [String] a unique identifier for the input.
    attr_reader :id

    # @return [Array] the options or option groups to display.
    attr_reader :items

    # @return [String] the scoped name of the form input.
    attr_reader :name

    # @return [String] the currently selected value.
    attr_reader :value

    # @return [Boolean] if true, renders the select input as disabled.
    def disabled?
      !!@options[:disabled]
    end

    # @return [Boolean] if true, prepends a blank option with empty value to the
    #   select options.
    def include_blank?
      !!@options[:include_blank]
    end

    private

    def attributes
      hsh = {}

      hsh[:class] = class_names if class_names.present?

      hsh
    end

    def build_item(item)
      if item.key?(:separator)
        build_separator
      elsif item.key?(:items)
        Librum::Core::View::Components::FormSelect::OptionGroup.new(**item)
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

    def class_names
      names = %w[select]

      names << 'is-danger' if matching_errors.any?

      names.join(' ')
    end

    def empty_item
      {
        label: ' ',
        value: ''
      }
    end

    def items_with_options
      ary = items
      ary = select_items(items: ary, value: value.to_s) if value.present?

      return ary unless include_blank?

      [empty_item, *ary]
    end

    def render_item(item)
      render(build_item(item))
    end

    def select_attributes
      hsh = { name: name }

      hsh[:disabled] = true if disabled?
      hsh[:id]       = id   if id.present?

      hsh
    end

    def select_item(item:, value:)
      if item.key?(:value) && item[:value].to_s == value
        item.merge(selected: true)
      elsif item.key?(:items)
        item.merge(items: select_items(items: item[:items], value: value))
      else
        item
      end
    end

    def select_items(items:, value:)
      items.map { |item| select_item(item: item, value: value) }
    end
  end
end
