# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders an internal or external link.
  class Link < ViewComponent::Base
    # @param url [String] the url for the link.
    # @param button [Boolean] if true, the link is rendered as a button.
    #   Defaults to false.
    # @param class_names [Array<String>, String] additional class names to add
    #   to the rendered HTML.
    # @param color [String] the color of the link.
    # @param icon [String] the icon to display in the link, if any.
    # @param label [String] the label for the link. Defaults to the url.
    # @param light [Boolean] if true, a button link is rendered in light style.
    #   Defaults to false.
    # @param outline [Boolean] if true, a button link is rendered in outline
    #   style. Defaults to false.
    def initialize( # rubocop:disable Metrics/ParameterLists
      url,
      button:      false,
      class_names: [],
      color:       nil,
      icon:        nil,
      label:       nil,
      light:       false,
      outline:     false
    )
      super()

      @url         = url
      @button      = button
      @class_names = Array(class_names)
      @color       = color
      @icon        = icon
      @label       = label || url
      @light       = light
      @outline     = outline
      @external    = url.include?('.') || url.include?(':')
    end

    # @return [String] the color of the link.
    attr_reader :color

    # @return [String] the icon to display in the link, if any.
    attr_reader :icon

    # @return [String] the label for the link.
    attr_reader :label

    # @return [String] the url for the link.
    attr_reader :url

    # @return [Boolean] if true, the link is rendered as a button.
    def button?
      @button.present?
    end

    # @return [String] additional class names to add to the rendered HTML.
    def class_names
      ary = @class_names.dup

      if button?
        ary.concat(button_class_names)
      elsif color.present?
        ary << "has-text-#{color}"
      else
        ary << 'has-text-link'
      end

      ary.join(' ')
    end

    # @return [true, false, nil] true if the link is to an external url,
    #   otherwise false.
    def external?
      @external
    end

    # @return [Boolean] if true, a button link is rendered in light style.
    def light?
      @light
    end

    # @return [Boolean] if true, a button link is rendered in outline style.
    def outline?
      @outline.present?
    end

    private

    def button_class_names
      ary = []

      ary << 'button'
      ary << "is-#{color}" if color
      ary << 'is-light'    if light?
      ary << 'is-outlined' if outline?

      ary
    end

    def target
      external? ? '_blank' : '_self'
    end

    def url_with_protocol
      return url unless external?

      return url if url.include?(':')

      "https://#{url}"
    end
  end
end
