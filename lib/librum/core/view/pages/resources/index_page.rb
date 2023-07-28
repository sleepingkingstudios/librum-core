# frozen_string_literal: true

module Librum::Core::View::Pages::Resources
  # Generic page for displaying a table of resource results.
  class IndexPage < Librum::Core::View::Components::Page
    extend Forwardable

    def_delegators :@resource,
      :resource_name,
      :singular_resource_name

    # @return [Array<#[]>] the resource data to render in the table.
    def resource_data
      return [] unless result.value.is_a?(Hash)

      result.value.fetch(resource_name, [])
    end

    private

    def build_data_table
      if table_component.blank?
        return Librum::Core::View::Components::MissingComponent.new(
          name:    'Table',
          message: 'Rendered in Librum::Core::View::Pages::Resources::IndexPage'
        )
      end

      table_component.new(data: resource_data, resource: resource)
    end

    def buttons
      [
        {
          color: 'primary',
          label: "Create #{singular_resource_name.titleize}",
          light: true,
          url:   resource.routes.new_path
        }
      ]
    end

    def render_data_table
      render(build_data_table)
    end

    def table_component
      return nil unless resource.respond_to?(:table_component)

      resource.table_component
    end
  end
end
