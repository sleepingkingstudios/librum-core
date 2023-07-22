# frozen_string_literal: true

module Librum::Core::View::Pages::Resources
  # Abstract page for displaying a resource form.
  class ResourceFormPage < Librum::Core::View::Pages::Resources::ResourcePage
    # @return [Stannum::Errors] the errors object for the form.
    def form_errors
      return unless result.error.is_a?(Cuprum::Error)

      return unless result.error.respond_to?(:errors)

      result.error.errors&.with_messages
    end

    private

    def build_data_form
      return build_missing_component('Form') if form_component.blank?

      form_component.new(
        action:   form_action,
        data:     data,
        errors:   form_errors,
        resource: resource
      )
    end

    def form_action
      self.class.name.split('::').last.gsub(/Page\z/, '').underscore
    end

    def form_component
      return nil unless resource.respond_to?(:form_component)

      resource.form_component
    end

    def render_data_form
      render(build_data_form)
    end
  end
end
