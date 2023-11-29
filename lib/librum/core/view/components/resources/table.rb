# frozen_string_literal: true

module Librum::Core::View::Components::Resources
  # Renders data from a resourceful index action.
  class Table < Librum::Core::View::Components::DataTable
    extend Forwardable

    # @param columns [Array<DataField::FieldDefinition>] the columns used to
    #   render the table.
    # @param data [Array<#[]>] the table data to render.
    # @param resource [Cuprum::Rails::Resource] the controller resource.
    # @param routes [Cuprum::Rails::Routes] the routes for the resource.
    # @param options [Hash] additional options for the table.
    def initialize(columns:, data:, resource:, routes: nil, **options)
      @resource = resource
      @routes   = routes || resource.routes

      super(
        class_names:   %w[is-striped],
        columns:       columns,
        data:          data,
        empty_message: empty_message,
        **options
      )
    end

    # @return resource [Cuprum::Rails::Resource] the controller resource.
    attr_reader :resource

    # @return [Cuprum::Rails::Routes] the routes for the resource.
    attr_reader :routes

    # @return [String] the message to display when the table is empty.
    def empty_message
      "There are no #{resource.name.tr('_', ' ')} matching the criteria."
    end
  end
end
