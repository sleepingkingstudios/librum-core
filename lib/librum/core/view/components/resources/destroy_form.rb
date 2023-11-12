# frozen_string_literal: true

module Librum::Core::View::Components::Resources
  # Renders a form to destroy the given resource.
  class DestroyForm < ViewComponent::Base
    extend Forwardable

    # @param data [#[]] the record to destroy.
    # @param resource [Cuprum::Rails::Resource] the current controller resource.
    # @param routes [Cuprum::Rails::Routes] the routes for the resource.
    # @param options [Hash{Symbol=>Object}] additional options to pass to the
    #   button.
    def initialize(data:, resource:, routes: nil, **options)
      super()

      @data     = data
      @resource = resource
      @routes   = routes || resource.routes
      @options  = options
    end

    def_delegators :@resource,
      :singular_resource_name

    # @return [#[]] the record to destroy.
    attr_reader :data

    # @return [Hash{Symbol=>Object}] additional options to pass to the button.
    attr_reader :options

    # @return [Cuprum::Rails::Resource] the current controller resource.
    attr_reader :resource

    # @return [Cuprum::Rails::Routes] the routes for the resource.
    attr_reader :routes

    private

    def build_button
      Librum::Core::View::Components::Button.new(
        color: 'danger',
        label: "Destroy #{singular_resource_name.titleize}",
        type:  'submit',
        **options
      )
    end

    def destroy_resource_path
      return routes.destroy_path if resource.singular?

      routes.destroy_path(data['slug'])
    end

    def render_button
      render(build_button)
    end

    def render_form(&block)
      form_with(
        model:  data,
        method: 'delete',
        url:    destroy_resource_path,
        &block
      )
    end
  end
end
