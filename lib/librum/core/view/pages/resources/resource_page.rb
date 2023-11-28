# frozen_string_literal: true

module Librum::Core::View::Pages::Resources
  # Abstract page for displaying a resource member.
  class ResourcePage < Librum::Core::View::Components::Page
    extend Forwardable

    def_delegators :@resource, :actions

    # @return [#[]] the data to display on the page.
    def data
      return default_data if result.value.nil?

      result.value
    end

    # @return [#[]] the data for the displayed resource record.
    def resource_data
      return data unless data.is_a?(Hash)

      data.fetch(resource.singular_name)
    end

    # @return [Cuprum::Rails::Routes] the resource routes.
    def routes
      @routes ||=
        resource.routes.with_wildcards(request.path_parameters.stringify_keys)
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
        resource.singular_name.titleize
    end
  end
end
