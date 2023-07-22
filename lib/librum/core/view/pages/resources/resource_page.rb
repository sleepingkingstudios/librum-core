# frozen_string_literal: true

module Librum::Core::View::Pages::Resources
  # Abstract page for displaying a resource member.
  class ResourcePage < Librum::Core::View::Components::Page
    extend Forwardable

    def_delegators :@resource,
      :resource_name,
      :singular_resource_name

    # @return [#[]] the data to display on the page.
    def data
      return default_data if result.value.nil?

      result.value
    end

    # @return [#[]] the data for the displayed resource record.
    def resource_data
      return data unless data.is_a?(Hash)

      data.fetch(singular_resource_name)
    end

    private

    def build_missing_component(component_name)
      Librum::Core::View::Components::MissingComponent.new(
        name:    component_name,
        message: "Rendered in #{self.class.name}"
      )
    end

    def default_data
      nil
    end

    def record_name
      (resource_data && resource_data['name']) ||
        singular_resource_name.titleize
    end
  end
end
