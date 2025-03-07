# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders a button inside a form for performing non-GET requests.
  class ButtonWithForm < ViewComponent::Base
    include Librum::Core::View::Options

    # @param label [String] the button label.
    # @param url [String] the url for the button.
    # @param options [Hash] additional options for the button.
    #
    # @param http_method [String] the HTTP method for the form. Defaults to GET.
    def initialize(label:, url:, **)
      super(**)

      @label = label
      @url   = url
    end

    # @return [String] the button label.
    attr_reader :label

    # @return [String] the url for the button.
    attr_reader :url

    option :http_method, default: 'post'

    private

    def build_button
      Librum::Core::View::Components::Button.new(
        label: label,
        type:  'submit',
        **options.except(:http_method)
      )
    end

    def render_button
      render(build_button)
    end

    def render_form(&)
      form_with(
        method: http_method,
        url:    url,
        &
      )
    end
  end
end
