# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders a visual icon.
  class Icon < ViewComponent::Base
    include Librum::Core::View::Options
    include Librum::Core::View::ClassName

    # @param icon [String] the icon to render.
    # @param options [Hash] additional options for rendering the icon.
    #
    # @option options animation [String] renders the icon with the given
    #   animation.
    # @option options bordered [Boolean] if true, renders the icon with a
    #   border.
    # @option options class_name [String, Array<String>] additional CSS class
    #   names for the icon.
    # @option options color [String, nil] the color of the icon.
    # @option options fixed_width [Boolean] if true, renders the icon with a
    #   fixed width.
    # @option options size [String, nil] the size of the icon.
    def initialize(icon:, **options)
      super(**options)

      @icon = icon
    end

    option :animation

    option :bordered?, boolean: true

    option :color

    option :fixed_width?, boolean: true

    option :size

    # @return [String] the icon to render.
    attr_reader :icon

    # @return [String] the rendered component.
    def call
      tag.span(class: span_class_names) do
        tag.i(class: icon_class_names)
      end
    end

    private

    def icon_class_names
      ary = ['fas', "fa-#{icon}"]

      ary << 'fa-border'       if bordered?
      ary << 'fa-fw'           if fixed_width?
      ary << "fa-#{animation}" if animation
      ary << icon_size         if icon_size

      ary
    end

    def icon_size
      case size
      when 'medium'
        'fa-lg'
      when 'large'
        'fa-2x'
      end
    end

    def span_class_names
      ary = ['icon', *class_name]

      ary << "has-text-#{color}" if color
      ary << "is-#{size}"        if size

      ary
    end
  end
end
