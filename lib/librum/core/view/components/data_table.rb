# frozen_string_literal: true

require 'librum/core/view/components'
require 'librum/core/view/components/data_field'

module Librum::Core::View::Components
  # Renders tabular data.
  class DataTable < ViewComponent::Base
    # @param columns [Array<DataField::FieldDefinition>] the columns used to
    #   render the table.
    # @param data [Array<Hash{String=>Object}>] the table data to render.
    # @param class_names [Array<String>] additional class names to add to the
    #   rendered HTML.
    # @param empty_message [String] the message to display for an empty table.
    # @param body_component [ViewComponent::Base] the component to render the
    #   table body. Defaults to View::Components::Table::Body.
    # @param cell_component [ViewComponent::Base] the component to render each
    #   table cell.
    # @param footer_component [ViewComponent::Base] the component to render the
    #   table footer, if any. Defaults to nil.
    # @param header_component [ViewComponent::Base] the component to render the
    #   table header. Defaults to View::Components::Table::Header.
    # @param row_component [ViewComponent::Base] the component to render each
    #   table row.
    # @param options [Hash{Symbol=>Object}] additional options to pass to the
    #   rendered table.
    #
    # @option options [ViewComponent::Base] :cell_component the component used
    #   to render each table cell. Defaults to
    #   Librum::Core::View::Components::DataTable::Cell.
    # @option options [ViewComponent::Base] :row_component the component to
    #   render each table row. Defaults to
    #   Librum::Core::View::Components::DataTable::Row.
    def initialize( # rubocop:disable Metrics/MethodLength
      columns:,
      data:,
      class_names: [],
      empty_message: nil,
      **options
    )
      super()

      @class_names      = class_names
      @columns          = columns
      @data             = data
      @empty_message    = empty_message
      @options          = options.dup
      @body_component   =
        @options.delete(:body_component) ||
        Librum::Core::View::Components::DataTable::Body
      @cell_component   =
        @options.delete(:cell_component) ||
        Librum::Core::View::Components::DataField
      @footer_component =
        @options.delete(:footer_component)
      @header_component =
        @options.delete(:header_component) ||
        Librum::Core::View::Components::DataTable::Header
      @row_component    =
        @options.delete(:row_component) ||
        Librum::Core::View::Components::DataTable::Row
    end

    # @return [ViewComponent::Base] the component to render the table body.
    attr_reader :body_component

    # @returen [ViewComponent::Base] the component to render each table cell.
    attr_reader :cell_component

    # @return [Array<DataField::FieldDefinition>] the columns used to render the
    #   table.
    attr_reader :columns

    # @return data [Array<Hash{String=>Object}>] the table data to render.
    attr_reader :data

    # @return [String] the message to display for an empty table.
    attr_reader :empty_message

    # @return [ViewComponent::Base] the component to render the table footer,
    #   if any.
    attr_reader :footer_component

    # @return [ViewComponent::Base] the component to render the table header.
    attr_reader :header_component

    # @return [Hash{Symbol=>Object}] additional options to pass to the rendered
    #   table.
    attr_reader :options

    # @return [ViewComponent::Base] the component to render each table row.
    attr_reader :row_component

    private

    def build_body
      body_component.new(
        cell_component: cell_component,
        columns:        columns,
        data:           data,
        empty_message:  empty_message,
        row_component:  row_component,
        **options
      )
    end

    def build_footer
      footer_component.new(**options)
    end

    def build_header
      header_component.new(
        columns: columns,
        **options
      )
    end

    def class_names
      ['table', *@class_names].join(' ')
    end

    def render_body
      render(build_body)
    end

    def render_footer
      return unless footer_component

      render(build_footer)
    end

    def render_header
      render(build_header)
    end
  end
end

require 'librum/core/view/components/data_table/body'
require 'librum/core/view/components/data_table/header'
require 'librum/core/view/components/data_table/row'
