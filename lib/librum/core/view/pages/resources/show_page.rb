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

    def render_data_block
      render(build_data_block)
    end
  end
end
