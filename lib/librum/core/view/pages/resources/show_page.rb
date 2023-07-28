# frozen_string_literal: true

module Librum::Core::View::Pages::Resources
  # Generic page for displaying a resource result.
  class ShowPage < Librum::Core::View::Pages::Resources::ResourcePage
    private

    def block_component
      return nil unless resource.respond_to?(:block_component)

      resource.block_component
    end

    def build_data_block
      return build_missing_component('Block') if block_component.blank?

      block_component.new(data: resource_data, resource: resource)
    end

    def buttons
      return [] unless resource_data

      buttons = []

      buttons << update_button if actions.include?('update')
      buttons << destroy_form  if actions.include?('destroy')

      buttons
    end

    def destroy_form
      Librum::Core::View::Components::Resources::DestroyForm.new(
        data:     resource_data,
        light:    true,
        resource: resource
      )
    end

    def edit_resource_path
      return resource.routes.edit_path if resource.singular?

      resource.routes.edit_path(resource_data['slug'])
    end

    def render_data_block
      render(build_data_block)
    end

    def update_button
      {
        color: 'warning',
        label: "Update #{singular_resource_name.titleize}",
        light: true,
        url:   edit_resource_path
      }
    end
  end
end
