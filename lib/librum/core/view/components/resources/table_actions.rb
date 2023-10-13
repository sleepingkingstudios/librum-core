# frozen_string_literal: true

module Librum::Core::View::Components::Resources
  # Renders actions for a resourceful table.
  class TableActions < ViewComponent::Base
    extend Forwardable

    # @param data [#[]] the record to render actions for.
    # @param resource [Cuprum::Rails::Resource] the current controller resource.
    def initialize(data:, resource:, **options)
      super()

      @data     = data
      @resource = resource
      @options  = options
    end

    def_delegators :@resource,
      :actions,
      :singular_resource_name

    # @return [#[]] the record to render actions for.
    attr_reader :data

    # @return [Cuprum::Rails::Resource] the current controller resource.
    attr_reader :resource

    private

    def build_destroy_form
      Librum::Core::View::Components::Resources::DestroyForm.new(
        class_names: 'is-small',
        data:        data,
        label:       'Destroy',
        light:       true,
        resource:    resource
      )
    end

    def build_edit_link
      Librum::Core::View::Components::Link.new(
        resource.routes.edit_path(data['slug']),
        button:     true,
        class_name: 'is-small',
        color:      'warning',
        label:      'Update',
        light:      true
      )
    end

    def build_show_link
      Librum::Core::View::Components::Link.new(
        resource.routes.show_path(data['slug']),
        button:     true,
        class_name: 'is-small',
        color:      'link',
        label:      'Show',
        light:      true
      )
    end

    def render_destroy_form
      render(build_destroy_form)
    end

    def render_edit_link
      render(build_edit_link)
    end

    def render_show_link
      render(build_show_link)
    end
  end
end
