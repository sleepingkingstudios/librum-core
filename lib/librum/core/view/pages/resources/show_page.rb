# frozen_string_literal: true

require 'librum/core/view/components/link'
require 'librum/core/view/components/missing_component'
require 'librum/core/view/components/page'
require 'librum/core/view/pages/resources'

module Librum::Core::View::Pages::Resources
  # Generic page for displaying a resource result.
  class ShowPage < Librum::Core::View::Components::Page
    extend Forwardable

    def_delegators :@resource,
      :resource_name,
      :singular_resource_name

    # @return [#[]] the resource data to render in the block.
    def resource_data
      return {} unless result.value.is_a?(Hash)

      result.value.fetch(singular_resource_name, {})
    end

    private

    def block_component
      return nil unless resource.respond_to?(:block_component)

      resource.block_component
    end

    def build_data_block
      if block_component.blank?
        return Librum::Core::View::Components::MissingComponent.new(
          name:    'Block',
          message: 'Rendered in View::Pages::Resources::ShowPage'
        )
      end

      block_component.new(data: resource_data, resource: resource)
    end

    def record_name
      resource_data['name'] || singular_resource_name.titleize
    end

    def render_data_block
      render(build_data_block)
    end
  end
end
