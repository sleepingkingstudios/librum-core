# frozen_string_literal: true

module Librum::Core::View::Components::Resources
  # Renders a form to destroy the given resource.
  class DestroyForm < ViewComponent::Base
    extend Forwardable

    # @param data [#[]] the record to destroy.
    # @param resource [Cuprum::Rails::Resource] the current controller resource.
    # @param options [Hash{Symbol=>Object}] additional options to pass to the
    #   button.
    def initialize(data:, resource:, **options)
      super()

      @data     = data
      @resource = resource
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

    private

    def build_button
      Librum::Core::View::Components::Button.new(
        color: 'danger',
        label: "Destroy #{singular_resource_name.titleize}",
        type:  'submit',
        **options
      )
    end

    def render_button
      render(build_button)
    end

    def render_form(&block)
      form_with(
        model:  data,
        method: 'delete',
        url:    resource.routes.destroy_path(data['slug']),
        &block
      )
    end
  end
end
