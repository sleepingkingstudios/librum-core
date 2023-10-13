# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders an internal or external link.
  class Link < ViewComponent::Base
    include Librum::Core::View::Options
    include Librum::Core::View::ClassName

    # @param url [String] the url for the link.
    # @param label [String] the label for the link. Defaults to the url.
    # @param options [Hash] additional options for the link.
    #
    # @option options button [Boolean] if true, the link is rendered as a
    #   button. Defaults to false.
    # @option options class_name [String, Array<String>] additional CSS class
    #   names for the link.
    # @option options color [String] the color of the link.
    # @option options icon [String] the icon to display in the link, if any.
    # @option options light [Boolean] if true, a button link is rendered in
    #   light style. Defaults to false.
    # @option options outline [Boolean] if true, a button link is rendered in
    #   outline style. Defaults to false.
    def initialize(url, label: nil, **options)
      super(**options)

      @url   = url
      @label = label || url
    end

    option :button, boolean: true

    option :color

    option :icon

    option :light, boolean: true

    option :outline, boolean: true

    # @return [String] the label for the link.
    attr_reader :label

    # @return [String] the url for the link.
    attr_reader :url

    # @return [true, false, nil] true if the link is to an external url,
    #   otherwise false.
    def external?
      @external ||= (url.include?('.') || url.include?(':'))
    end

    private

    def attributes
      {
        class:  class_names,
        href:   url_with_protocol,
        target: target
      }
    end

    def button_class_names
      ary = []

      ary << 'button'
      ary << "is-#{color}" if color
      ary << 'is-light'    if light?
      ary << 'is-outlined' if outline?

      ary
    end

    def class_names
      ary = [*class_name]

      if button?
        ary.concat(button_class_names)
      elsif color.present?
        ary << "has-text-#{color}"
      else
        ary << 'has-text-link'
      end

      ary.join(' ')
    end

    def render_icon?
      icon.present?
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
