# frozen_string_literal: true

require 'stannum/errors'

require 'librum/core/view/components/missing_component'
require 'librum/core/view/components/page'
require 'librum/core/view/pages/resources'

module Librum::Core::View::Pages::Resources
  # Generic page for editing a resource.
  class EditPage < Librum::Core::View::Components::Page
    extend Forwardable

    def_delegators :@resource,
      :resource_name,
      :singular_resource_name

    # @return [Stannum::Errors] the errors object for the form.
    def form_errors
      return unless result.error.is_a?(Cuprum::Error)

      return unless result.error.respond_to?(:errors)

      result.error.errors&.with_messages
    end

    # @return [#[]] the resource data to render in the block.
    def resource_data
      return {} unless result.value.is_a?(Hash)

      result.value.fetch(singular_resource_name, {})
    end

    private

    def build_data_form
      return build_missing_component if form_component.blank?

      form_component.new(
        data:     resource_data,
        errors:   form_errors,
        resource: resource
      )
    end

    def build_missing_component
      Librum::Core::View::Components::MissingComponent.new(
        name:    'Form',
        message: 'Rendered in Librum::Core::View::Pages::Resources::EditPage'
      )
    end

    def form_component
      return nil unless resource.respond_to?(:form_component)

      resource.form_component
    end

    def record_name
      resource_data['name'] || singular_resource_name.titleize
    end

    def render_data_form
      render(build_data_form)
    end
  end
end
