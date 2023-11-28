# frozen_string_literal: true

module Librum::Core::View::Pages::Resources
  # Generic page for displaying a table of resource results.
  class IndexPage < Librum::Core::View::Components::Page
    extend Forwardable

    # @return [Array<#[]>] the resource data to render in the table.
    def resource_data
      return [] unless result.value.is_a?(Hash)

      result.value.fetch(resource.name, [])
    end

    # @return [Cuprum::Rails::Routes] the resource routes.
    def routes
      @routes ||=
        resource.routes.with_wildcards(request.path_parameters.stringify_keys)
    end

    private

    def build_data_table
      return missing_table_component if table_component.blank?

      table_component.new(
        data:     resource_data,
        resource: resource,
        routes:   routes
      )
    end

    def buttons
      buttons = []

      buttons << create_button if resource.actions.include?('create')

      buttons
    end

    def create_button
      {
        color: 'primary',
        label: "Create #{resource.singular_name.titleize}",
        light: true,
        url:   routes.new_path
      }
    end

    def missing_table_component
      Librum::Core::View::Components::MissingComponent.new(
        name:    'Table',
        message: 'Rendered in Librum::Core::View::Pages::Resources::IndexPage'
      )
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
