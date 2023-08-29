# frozen_string_literal: true

module Librum::Core::View::Components::Resources
  # Renders data from a resourceful index action.
  class Table < Librum::Core::View::Components::DataTable
    extend Forwardable

    # @param columns [Array<DataField::FieldDefinition>] the columns used to
    #   render the table.
    # @param data [Array<#[]>] the table data to render.
    # @param resource [Cuprum::Rails::Resource] the controller resource.
    def initialize(columns:, data:, resource:)
      @resource = resource

      super(
        class_names:   %w[is-striped],
        columns:       columns,
        data:          data,
        empty_message: empty_message
      )
    end

    def_delegators :@resource,
      :resource_name

    # @return resource [Cuprum::Rails::Resource] the controller resource.
    attr_reader :resource

    # @return [String] the message to display when the table is empty.
    def empty_message
      "There are no #{resource_name.tr('_', ' ')} matching the criteria."
    end
  end
end
