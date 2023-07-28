# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders a button component.
  class Button < ViewComponent::Base
    # @param class_names [Array<String>] additional class names to render.
    # @param color [String] the color of the button.
    # @param label [String] the button label.
    # @param light [Boolean] if true, a button link is rendered in light style.
    #   Defaults to false.
    # @param outline [Boolean] if true, the button is rendered in outline style.
    #   Defaults to false.
    # @param type [String] the type of button, either "button", "link", "reset",
    #   or "submit".
    def initialize( # rubocop:disable Metrics/ParameterLists
      class_names: nil,
      color:       nil,
      label:       nil,
      light:       false,
      outline:     false,
      type:        'button'
    )
      super()

      @class_names = class_names
      @color       = color
      @label       = label
      @light       = light
      @outline     = outline
      @type        = type
    end

    # @return [String] the color of the button.
    attr_reader :color

    # @return [String] the button label.
    attr_reader :label

    # @return [String] the type of button, either "button", "reset" or "submit".
    attr_reader :type

    # @return [Boolean] if true, a button link is rendered in light style.
    def light?
      @light
    end

    # @return [Boolean] true if the link is styled as an outline button.
    def outline?
      @outline.present?
    end

    private

    def class_names
      names = %w[button]

      names << "is-#{color}" if color
      names << 'is-light'    if light?
      names << 'is-outlined' if outline?

      names += Array(@class_names)

      names.join(' ')
    end
  end
end
