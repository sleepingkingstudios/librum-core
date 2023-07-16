# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders an internal or external link.
  class Link < ViewComponent::Base
    # @param url [String] the url for the link.
    # @param class_names [Array<String>, String] additional class names to add
    #   to the rendered HTML.
    # @param color [String] the color of the link.
    # @param icon [String] the icon to display in the link, if any.
    # @param label [String] the label for the link. Defaults to the url.
    def initialize(url, class_names: [], color: 'link', icon: nil, label: nil)
      super()

      @url         = url
      @class_names = Array(class_names)
      @color       = color
      @icon        = icon
      @label       = label || url
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

    # @return [String] additional class names to add to the rendered HTML.
    def class_names
      ary = @class_names.dup

      ary << "has-text-#{color}"

      ary.join(' ')
    end

    # @return [true, false, nil] true if the link is to an external url,
    #   otherwise false.
    def external?
      @external
    end

    private

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
