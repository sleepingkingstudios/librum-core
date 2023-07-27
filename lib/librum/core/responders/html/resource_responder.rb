# frozen_string_literal: true

require 'cuprum/collections/errors/not_found'

module Librum::Core::Responders::Html
  # Delegates missing pages to View::Pages::Resources.
  class ResourceResponder < Librum::Core::Responders::Html::ViewResponder
    action :create do
      match :success do |result|
        record = result.value[resource.singular_resource_name]

        redirect_to(
          resource.routes.show_path(record.slug),
          flash: success_flash('created')
        )
      end

      match :failure, error: Cuprum::Collections::Errors::FailedValidation \
      do |result|
        render_component(
          result,
          action: 'new',
          flash:  failure_flash('create')
        )
      end
    end

    action :destroy do
      match :success do
        redirect_to(
          resource.routes.index_path,
          flash: destroy_flash
        )
      end

      match :failure do
        redirect_back(flash: failure_flash('destroy'))
      end
    end

    action :update do
      match :success do |result|
        record = result.value[resource.singular_resource_name]

        redirect_to(
          resource.routes.show_path(record.slug),
          flash: success_flash('updated')
        )
      end

      match :failure, error: Cuprum::Collections::Errors::FailedValidation \
      do |result|
        render_component(
          result,
          action: 'edit',
          flash:  failure_flash('update')
        )
      end
    end

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

    def destroy_flash
      message = Kernel.format(
        'Successfully destroyed %<resource>s',
        resource: resource.singular_resource_name.titleize
      )

      { danger: { icon: 'bomb', message: message } }
    end

    def failure_flash(action)
      message = Kernel.format(
        'Unable to %<action>s %<resource>s',
        action:   action,
        resource: resource.singular_resource_name.titleize
      )

      { warning: { icon: 'exclamation-triangle', message: message } }
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

    def success_flash(action)
      message = Kernel.format(
        'Successfully %<action>s %<resource>s',
        action:   action,
        resource: resource.singular_resource_name.titleize
      )

      { success: { icon: 'circle-check', message: message } }
    end
  end
end
