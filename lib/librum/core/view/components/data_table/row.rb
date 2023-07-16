# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders a data table row.
  class DataTable::Row < ViewComponent::Base
    # @param columns [Array<DataField::FieldDefinition>] the columns used to
    #   render the table.
    # @param data [#[]] the data object for the row.
    # @param options [Hash{Symbol=>Object}] additional options to pass to the
    #   rendered row.
    #
    # @option options [ViewComponent::Base] :cell_component the component used
    #   to render each table cell. Defaults to
    #   Librum::Core::View::Components::DataTable::Cell.
    def initialize(columns:, data:, **options)
      super()

      @columns        = columns
      @data           = data
      @options        = options.dup
      @cell_component =
        @options.delete(:cell_component) ||
        Librum::Core::View::Components::DataField
    end

    # @return [ViewComponent::Base] the component to render each table cell.
    attr_reader :cell_component

    # @return [Array<DataField::FieldDefinition>] the columns used to render the
    #   table.
    attr_reader :columns

    # @return [#[]] the data object for the row.
    attr_reader :data

    # @return [Hash{Symbol=>Object}] additional options to pass to the rendered
    #   cell.
    attr_reader :options

    private

    def build_cell(column:)
      cell_component.new(field: column, data: data, **options)
    end

    def render_cell(column:)
      render(build_cell(column: column))
    end
  end
end
