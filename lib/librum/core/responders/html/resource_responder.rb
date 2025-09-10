# frozen_string_literal: true

require 'cuprum/collections/errors/not_found'

module Librum::Core::Responders::Html
  # Delegates missing pages to View::Pages::Resources.
  class ResourceResponder < Librum::Core::Responders::Html::ViewResponder # rubocop:disable Metrics/ClassLength
    action :create do
      match :success do |result|
        record = result.value[resource.singular_name]
        path   =
          resource.singular? ? routes.show_path : routes.show_path(record.slug)

        redirect_to(path, flash: success_flash('created'))
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
        path = resource.singular? ? routes.show_path : routes.index_path

        redirect_to(path, flash: destroy_flash)
      end

      match :failure do
        redirect_back(flash: failure_flash('destroy'))
      end
    end

    action :update do
      match :success do |result|
        record = result.value[resource.singular_name]
        path   =
          resource.singular? ? routes.show_path : routes.show_path(record.slug)

        redirect_to(path, flash: success_flash('updated'))
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
      handle_not_found_error(result)
    end

    private

    def destroy_flash
      message = Kernel.format(
        'Successfully destroyed %<resource>s',
        resource: resource.singular_name.titleize
      )

      { danger: { icon: 'bomb', message: message } }
    end

    def failure_flash(action)
      message = Kernel.format(
        'Unable to %<action>s %<resource>s',
        action:   action,
        resource: resource.singular_name.titleize
      )

      { warning: { icon: 'exclamation-triangle', message: message } }
    end

    def find_component(action_name:, controller_name:, result:)
      component = super

      return component if component

      component_class =
        self.class.find_view.call(action: action_name, controller: 'Resources')

      if component_class
        return build_view(component_class, request:, resource:, result:)
      end

      nil
    end

    def handle_not_found_error(result)
      matching = matching_ancestor_for(result)

      return render_not_found_page(result) unless matching

      routes = matching.routes.with_wildcards(request.path_params || {})

      redirect_to(
        matching.singular? ? routes.show_path : routes.index_path,
        flash: not_found_flash(error: result.error, matching: matching)
      )
    end

    def matching_ancestor_for(result)
      name = result.error.collection_name

      resource.each_ancestor.find do |ancestor|
        ancestor.plural_name == name || ancestor.singular_name == name
      end
    end

    def not_found_flash(error:, matching: nil)
      resource_name =
        matching&.singular_name || error.collection_name.singularize
      message       = Kernel.format(
        '%<resource>s not found with key "%<value>s"',
        resource: resource_name.titleize,
        value:    error.attribute_value
      )

      { warning: { icon: 'exclamation-triangle', message: message } }
    end

    def render_not_found_page(result)
      render_component(
        result,
        flash:  not_found_flash(error: result.error),
        status: :not_found
      )
    end

    def success_flash(action)
      message = Kernel.format(
        'Successfully %<action>s %<resource>s',
        action:   action,
        resource: resource.singular_name.titleize
      )

      { success: { icon: 'circle-check', message: message } }
    end

    def view_paths_for(action_name:, controller_name:)
      super + self.class.find_view.view_paths(
        action:     action_name,
        controller: 'resources'
      )
    end
  end
end
