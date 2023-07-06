# frozen_string_literal: true

require 'librum/core/view/components'

module Librum::Core::View::Components
  # Renders a button component.
  class Button < ViewComponent::Base
    # @param class_names [Array<String>] additional class names to render.
    # @param color [String] the color of the button.
    # @param label [String] the button label.
    # @param type [String] the type of button, either "button", "link", "reset",
    #   or "submit".
    def initialize(
      class_names: nil,
      color:       nil,
      label:       nil,
      type:        'button'
    )
      super()

      @class_names = class_names
      @color       = color
      @label       = label
      @type        = type
    end

    # @return [String] the color of the button.
    attr_reader :color

    # @return [String] the button label.
    attr_reader :label

    # @return [String] the type of button, either "button", "reset" or "submit".
    attr_reader :type

    private

    def class_names
      names = %w[button]

      names << "is-#{color}" if color

      names += Array(@class_names)

      names.join(' ')
    end
  end
end
