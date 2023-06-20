# frozen_string_literal: true

require 'librum/core/responders/html'
require 'librum/core/responders/html/view_responder'

module Librum::Core::Responders::Html
  # Delegates missing pages to View::Pages::Resources.
  class ResourceResponder < Librum::Core::Responders::Html::ViewResponder
    match :failure, error: Cuprum::Collections::Errors::NotFound do |result|
      message = Kernel.format(
        '%<resource>s not found with key "%<value>s"',
        resource: resource.singular_resource_name.titleize,
        value:    result.error.attribute_value
      )

      redirect_to(
        resource.routes.index_path,
        flash: { warning: { icon: 'exclamation-triangle', message: message } }
      )
    end

    private

    def build_view_component(result)
      return super if Object.const_defined?(view_component_name)

      resource_component_class.new(result, resource: resource)
    end

    def resource_component_class
      resource_component_name.constantize
    end

    def resource_component_name
      action    = action_name.to_s.camelize
      page_name = "View::Pages::Resources::#{action}Page"

      return page_name if Object.const_defined?(page_name)

      "Librum::Core::#{page_name}"
    end
  end
end
