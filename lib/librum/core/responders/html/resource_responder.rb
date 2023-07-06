# frozen_string_literal: true

require 'cuprum/collections/errors/not_found'

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

    def build_view_component(result:, action: nil)
      return super if Object.const_defined?(view_component_name(action: action))

      resource_component_class(action: action).new(result, resource: resource)
    end

    def lazy_require(page_name)
      require page_name.split('::').map(&:underscore).join('/')
    rescue LoadError
      # Do nothing.
    end

    def resource_component_class(action: nil)
      resource_component_name(action: action).constantize
    end

    def resource_component_name(action: nil)
      action    = (action || action_name).to_s.camelize
      page_name = "View::Pages::Resources::#{action}Page"

      return page_name if Object.const_defined?(page_name)

      page_name = "Librum::Core::#{page_name}"

      lazy_require(page_name)

      page_name
    end
  end
end
