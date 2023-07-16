# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders the submit and cancel buttons for a form.
  class FormButtons < ViewComponent::Base
    # @param cancel_label [String] the label for the cancel button. Defaults to
    #   "Cancel".
    # @param cancel_url [String, nil] the url for the cancel button.
    # @param submit_label [String] the label for the submit button. Defaults to
    #    "Submit".
    def initialize(
      cancel_label: 'Cancel',
      cancel_url:   nil,
      submit_label: 'Submit'
    )
      super()

      @cancel_label = cancel_label
      @cancel_url   = cancel_url
      @submit_label = submit_label
    end

    # @return the label for the cancel button.
    attr_reader :cancel_label

    # @return [String, nil] the url for the cancel button.
    attr_reader :cancel_url

    # @return [String] the label for the submit button.
    attr_reader :submit_label

    private

    def build_cancel_button
      Librum::Core::View::Components::Link.new(
        cancel_url,
        class_names: %w[button is-fullwidth],
        color:       'black',
        label:       cancel_label
      )
    end

    def build_submit_button
      Librum::Core::View::Components::Button.new(
        class_names: %w[is-fullwidth],
        color:       'primary',
        label:       submit_label,
        type:        'submit'
      )
    end

    def cancel_button?
      cancel_url.present?
    end

    def render_cancel_button
      render(build_cancel_button)
    end

    def render_submit_button
      render(build_submit_button)
    end
  end
end
