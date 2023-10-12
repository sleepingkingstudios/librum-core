# frozen_string_literal: true

module Librum::Core::View::Layouts
  # Renders a page notification.
  class Page::Alert < ViewComponent::Base
    # @param color [String] the color of the notification.
    # @param icon [String] the name of the icon to display, if any.
    # @param message [String] the message to display.
    def initialize(message, color: nil, icon: nil)
      super()

      @color   = color
      @icon    = icon
      @message = message
    end

    # @return [String] the color of the notification.
    attr_reader :color

    # @return [String] the name of the icon to display, if any.
    attr_reader :icon

    # @return [String] the message to display.
    attr_reader :message

    private

    def class_names
      names = %i[notification]

      names << "is-#{color}" if color

      names.join(' ')
    end

    def render_icon?
      icon.present?
    end
  end
end
