# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders an alert.
  class Alert < ViewComponent::Base
    include Librum::Core::View::Options

    # @param message [String] the message to display.
    # @param options [Hash] options for rendering the alert.
    #
    # @option options color [String] the color of the notification.
    # @option options dismissable [Boolean] if true, renders a button to close
    #   the alert. Defaults to true.
    # @option options icon [String] the name of the icon to display, if any.
    #   Defaults to 'info'.
    def initialize(message, **options)
      super(**options)

      @message = message
    end

    option :color, default: 'info'

    option :dismissable, boolean: true, default: true

    option :icon

    # @return [String] the message to display.
    attr_reader :message

    private

    def attributes
      hsh = { 'class' => class_names }

      hsh['data-controller'] = 'dismissable' if dismissable?

      hsh
    end

    def class_names
      names = %i[alert notification]

      names << "is-#{color}" if color

      names.join(' ')
    end

    def render_icon?
      icon.present?
    end
  end
end
