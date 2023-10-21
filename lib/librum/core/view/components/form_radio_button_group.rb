# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders a field with multiple radio buttons.
  class FormRadioButtonGroup < ViewComponent::Base
    include Librum::Core::View::Options
    include Librum::Core::View::ClassName
    include Librum::Core::View::DataMatching
    include Librum::Core::View::FormErrors

    # @param data [#[]] the data for the form.
    # @param items [Hash] the values and labels for the radio buttons.
    # @param name [String] the scoped name of the form input.
    # @param value [String] the currently selected value, if any.
    # @param options [Hash] additional options for the input.
    #
    # @option options error_key [String] the key used to identify matching
    #   errors. Defaults to the input name.
    # @option options errors [Stannum::Errors, Array<String>] the form errors to
    #   apply.
    # @option options label [String] the label to display for the group.
    def initialize(name, items:, data: nil, value: nil, **options)
      super(**options)

      @data  = data
      @name  = name
      @items = items
      @label = label
      @value = value
    end

    option :label, default: lambda {
      name
        .gsub(']', '')
        .split(/[.\[]/)
        .last
        .titleize
    }

    # @return [#[]] the data for the form.
    attr_reader :data

    # @return [Hash] the values and labels for the radio buttons.
    attr_reader :items

    # @return [String] the scoped name of the form input.
    attr_reader :name

    # @return [String] the value to place in the input.
    def value
      return @value if @value

      matching_data
    end

    private

    def build_item(item)
      Librum::Core::View::Components::FormRadioButton.new(
        name,
        checked: item[:checked],
        errors:  matching_errors,
        label:   item[:label],
        value:   item[:value]
      )
    end

    def control_class_names
      names = %w[control]

      names << 'has-icons-right' if matching_errors.any?

      names.join(' ')
    end

    def field_class_names
      ['field', *class_name].join(' ')
    end

    def generate_label(item:)
      return item if item.key?(:label)

      item.merge(label: item[:value].to_s.titleize)
    end

    def items_with_options
      return items if items.blank?

      select_items(items: items, value: value.to_s)
    end

    def render_item(item)
      render(build_item(item))
    end

    def render_label?
      label.present?
    end

    def select_item(item:, value:)
      if item.key?(:value) && item[:value].to_s == value
        item.merge(checked: true)
      else
        item
      end
    end

    def select_items(items:, value:)
      items
        .map { |item| generate_label(item: item) }
        .map { |item| select_item(item: item, value: value) }
    end
  end
end
