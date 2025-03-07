# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders a visual component with text, an icon, or both.
  class IconText < ViewComponent::Base
    include Librum::Core::View::Options
    include Librum::Core::View::ClassName

    # @param contents [ViewComponent::Base, String, nil] the contents to render.
    # @param icon [String, nil] the icon to render.
    # @param options [Hash] additional options for rendering the icon text.
    #
    # @option options class_name [String, Array<String>] additional CSS class
    #   names for the icon.
    # @option options color [String, nil] the color of the icon.
    def initialize(contents:, icon:, **)
      super(**)

      @contents = contents
      @icon     = icon
    end

    option :color

    # @return [ViewComponent::Base, String, nil] the contents to render.
    attr_reader :contents

    # @return [String, nil] the icon to render.
    attr_reader :icon

    # @return [String, nil] the label to render.
    attr_reader :label

    private

    def build_icon
      Librum::Core::View::Components::Icon.new(icon: icon)
    end

    def render?
      render_contents? || render_icon?
    end

    def render_contents
      return unless render_contents?

      return render(contents) if contents.is_a?(ViewComponent::Base)

      tag.span { contents }
    end

    def render_contents?
      contents.present?
    end

    def render_icon
      return unless render_icon?

      render(build_icon)
    end

    def render_icon?
      icon.present?
    end

    def wrapper_class_names
      ary = ['icon-text', *class_name]

      ary << "has-text-#{color}" if color.present?

      ary.join(' ')
    end
  end
end
