# frozen_string_literal: true

require 'librum/core/view/components/data_field'
require 'librum/core/view/components/data_table'
require 'librum/core/view/components/data_table/row'

module Librum::Core::View::Components
  # Renders a table body.
  class DataTable::Body < ViewComponent::Base
    # @param columns [Array<DataField::FieldDefinition>] the columns used to
    #   render the table.
    # @param data [Array<#[]>] the table data to render.
    # @param empty_message [String, ViewComponent::Base] the message or
    #   component to display when the table has no data.
    # @param row_component [ViewComponent::Base]
    # @param options [Hash{Symbol=>Object}] additional options to pass to the
    #   rendered table body.
    #
    # @option options [ViewComponent::Base] :cell_component the component used
    #   to render each table cell. Defaults to
    #   Librum::Core::View::Components::DataTable::Cell.
    # @option options [ViewComponent::Base] :row_component the component to
    #   render each table row. Defaults to
    #   Librum::Core::View::Components::DataTable::Row.
    def initialize(columns:, data:, empty_message: nil, **options) # rubocop:disable Metrics/MethodLength
      super()

      @columns        = columns
      @data           = data
      @empty_message  = empty_message || 'There are no matching items.'
      @options        = options.dup
      @cell_component =
        @options.delete(:cell_component) ||
        Librum::Core::View::Components::DataField
      @row_component  =
        @options.delete(:row_component) ||
        Librum::Core::View::Components::DataTable::Row
    end

    # @return [ViewComponent::Base] the component to render each table cell.
    attr_reader :cell_component

    # @return [Array<DataField::FieldDefinition>] the columns used to render the
    #   table.
    attr_reader :columns

    # @return [Array<#[]>] the table data to render.
    attr_reader :data

    # @return [String, ViewComponent::Base] the message or component to display
    #   when the table has no data.
    attr_reader :empty_message

    # @return [Hash{Symbol=>Object}] additional options to pass to the rendered
    #   table body
    attr_reader :options

    # @return [ViewComponent::Base] the component to render each table row.
    attr_reader :row_component

    private

    def build_empty_message
      content_tag('tr') do
        content_tag('td', colspan: columns.size) { empty_message }
      end
    end

    def build_row(item:)
      row_component.new(
        cell_component: cell_component,
        columns:        columns,
        data:           item,
        **options
      )
    end

    def render_empty_message
      return render(empty_message) if empty_message.is_a?(ViewComponent::Base)

      build_empty_message
    end

    def render_row(item:)
      render(build_row(item: item))
    end
  end
end
