# frozen_string_literal: true

module Librum::Core::View::Components::Resources
  # Renders a form for a record.
  class Form < ViewComponent::Base
    extend Forwardable

    # @param action [String] the name of the rendered action.
    # @param data [#[]] the record to create or update.
    # @param errors [Stannum::Errors] the errors for the form.
    # @param resource [Cuprum::Rails::Resource] the current controller resource.
    # @param routes [Cuprum::Rails::Routes] the routes for the resource.
    def initialize(action:, data:, resource:, errors: nil, routes: nil, **) # rubocop:disable Metrics/ParameterLists
      super()

      @action   = action
      @data     = data || default_data
      @errors   = errors
      @resource = resource
      @routes   = routes || resource.routes
    end

    def_delegators :@resource,
      :singular_resource_name

    # @return [String] the name of the rendered action.
    attr_reader :action

    # @return [#[]] the record to create or update.
    attr_reader :data

    # @return [Stannum::Errors] the errors for the form.
    attr_reader :errors

    # @return [Cuprum::Rails::Resource] the current controller resource.
    attr_reader :resource

    # @return [Cuprum::Rails::Routes] the routes for the resource.
    attr_reader :routes

    # Builds and renders the form tag.
    #
    # @yield the form contents.
    def render_form(&block)
      form_with(
        model:  resource_data,
        method: form_method,
        url:    form_url,
        &block
      )
    end

    # Builds and renders the form buttons.
    def render_form_actions
      render(build_form_actions)
    end

    # Builds and renders a form field.
    #
    # @param name [String] the qualified name for the field.
    # @param options [Hash{Symbol=>Object}] options for the field.
    #
    # @see Librum::Core::View::Components::FormField.
    def render_form_field(name, **options)
      render(build_form_field(name, **options))
    end

    # Builds and renders a form radio button group.
    #
    # @param name [String] the qualified name for the button group.
    # @param items [Hash] the labels and values for the form buttons.
    # @param options [Hash{Symbol=>Object}] options for the button group.
    def render_form_radio_button_group(name, items:, **options)
      render(build_form_radio_button_group(name, items: items, **options))
    end

    # @return [#[]] the data for the displayed resource record.
    def resource_data
      return data unless data.is_a?(Hash)

      data.fetch(singular_resource_name)
    end

    private

    def build_form_actions
      Librum::Core::View::Components::FormButtons.new(
        cancel_url:   cancel_url,
        submit_label: submit_label
      )
    end

    def build_form_field(name, **options)
      Librum::Core::View::Components::FormField.new(
        name,
        data:   data,
        errors: errors,
        **options
      )
    end

    def build_form_radio_button_group(name, items:, **options)
      Librum::Core::View::Components::FormRadioButtonGroup.new(
        name,
        data:   data,
        errors: errors,
        items:  items,
        **options
      )
    end

    def cancel_url
      return routes.show_path(resource_data['slug']) if action == 'edit'

      routes.index_path
    end

    def create_url
      routes.create_path
    end

    def form_method
      action == 'edit' ? :patch : :post
    end

    def form_url
      action == 'edit' ? update_url : create_url
    end

    def submit_label
      action_label = action == 'edit' ? 'Update' : 'Create'

      "#{action_label} #{singular_resource_name.titleize}"
    end

    def update_url
      routes.update_path(resource_data['slug'])
    end
  end
end
