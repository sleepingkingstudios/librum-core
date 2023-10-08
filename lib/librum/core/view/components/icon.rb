# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders a visual icon.
  class Icon < ViewComponent::Base
    # @param icon [String] the icon to render.
    # @param color [String, nil] the color of the icon.
    # @param size [String, nil] the size of the icon.
    # @param options [Hash] additional options for rendering the icon.
    #
    # @option options animation [String] renders the icon with the given
    #   animation.
    # @option options bordered [Boolean] if true, renders the icon with a
    #   border.
    # @option options class_name [String, Array<String>] additional CSS class
    #   names for the icon.
    # @option options fixed_width [Boolean] if true, renders the icon with a
    #   fixed width.
    def initialize(icon:, color: nil, size: nil, **options)
      super()

      @icon    = icon
      @color   = color
      @size    = size
      @options = options
    end

    # @return [String, nil] the color of the icon.
    attr_reader :color

    # @return [String] the icon to render.
    attr_reader :icon

    # @return [Hash] additional options for rendering the icon.
    attr_reader :options

    # @return [String, nil] the size of the icon.
    attr_reader :size

    # @return [String] renders the icon with the given animation.
    def animation
      @options[:animation]
    end

    # @return [String] the rendered component.
    def call
      tag.span(class: span_class_names) do
        tag.i(class: icon_class_names)
      end
    end

    # @return [Array<String>] additional CSS class names for the icon.
    def class_name
      Array(@options.fetch(:class_name, []))
    end

    # @return [Boolean] if true, renders the icon with a border.
    def bordered?
      !!@options[:bordered]
    end

    # @return [Boolean] if true, renders the icon with a fixed width.
    def fixed_width?
      !!@options[:fixed_width]
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
