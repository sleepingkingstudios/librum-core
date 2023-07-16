# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders a visual component with text, an icon, or both.
  class IconText < ViewComponent::Base
    # @param icon [String, nil] the icon to render.
    # @param label [String, nil] the label to render.
    def initialize(icon:, label:)
      super()

      @icon  = icon
      @label = label
    end

    # @return [String, nil] the icon to render.
    attr_reader :icon

    # @return [String, nil] the label to render.
    attr_reader :label

    private

    def render_icon?
      icon.present?
    end

    def render_label?
      label.present?
    end
  end
end
