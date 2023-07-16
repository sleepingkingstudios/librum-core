# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders when an expected component is not configured.
  class MissingComponent < ViewComponent::Base
    # @param name [String] the name of the expected component.
    # @param icon [String] the icon to display.
    # @param label [String] the label to display. Defaults to the missing
    #   component name.
    # @param message [String] an optionl message to display.
    def initialize(name:, icon: 'bug', label: nil, message: nil)
      super()

      @icon    = icon
      @label   = label || "Missing Component #{name}"
      @name    = name
      @message = message
    end

    # @return [String] the icon to display.
    attr_reader :icon

    # @return [String] the label to display.
    attr_reader :label

    # @return [String] an optionl message to display.
    attr_reader :message

    # @return [String] the name of the expected component.
    attr_reader :name
  end
end
