# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders the fields of a data object.
  class DataList < ViewComponent::Base
    # @param data [Hash{String=>Object}] the data used to render the list item.
    # @param fields [FieldDefinition>] the configuration objects for rendering
    #   each list item.
    # @param item_component [ViewComponent::Base] the component used to render
    #   each list item. Defaults to Librum::Core::View::Components::DataField.
    # @param options [Hash{Symbol=>Object}] additional objects for rendering the
    #   data list.
    def initialize(data:, fields:, item_component: nil, **options)
      super()

      @data           = data
      @fields         = fields.map do |field|
        next field unless field.is_a?(Hash)

        Librum::Core::View::Components::DataField::FieldDefinition.new(**field)
      end
      @item_component =
        item_component || Librum::Core::View::Components::DataField
      @options        = options
    end

    # @return [Hash{String=>Object}] the data used to render the list item.
    attr_reader :data

    # @return [Array<FieldDefinition>] the configuration objects for rendering
    #   each list item.
    attr_reader :fields

    # @return [ViewComponent::Base] the component used to render each list item.
    attr_reader :item_component

    # @return [Hash{Symbol=>Object}] additional objects for rendering the data
    #   list.
    attr_reader :options

    private

    def build_item(field:)
      item_component.new(
        data:  data,
        field: field,
        **options
      )
    end

    def render_item(field:)
      render(build_item(field: field))
    end
  end
end
