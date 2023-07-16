# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders a data table header.
  class DataTable::Header < ViewComponent::Base
    # @param columns [Array<DataField::FieldDefinition>] the columns used to
    #   render the table.
    def initialize(columns:, **)
      super()

      @columns = columns.map do |column|
        next column unless column.is_a?(Hash)

        Librum::Core::View::Components::DataField::FieldDefinition.new(**column)
      end
    end

    # @return [Array<DataField::FieldDefinition>] the columns used to render the
    #   table.
    attr_reader :columns
  end
end
