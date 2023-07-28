# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders a page or section heading with optional buttons.
  class Heading < ViewComponent::Base
    # @param label [String] the label to display in the heading.
    # @param buttons [Array] the buttons to display, if any.
    # @param size [Integer] the size of heading, from 1 to 6.
    def initialize(label, buttons: [], size: nil)
      super()

      @label   = label
      @buttons = buttons
      @size    = size
    end

    # @return [Array] the buttons to display, if any.
    attr_reader :buttons

    # @return [String] the label to display in the heading.
    attr_reader :label

    # @return [Integer] the size of heading.
    attr_reader :size

    private

    def build_button(label:, url:, color: nil, **options)
      Librum::Core::View::Components::Link.new(
        url,
        button: true,
        color:  color,
        label:  label,
        **options
      )
    end

    def buttons?
      buttons.present?
    end

    def heading_class_names
      class_names = %w[title]

      class_names << "is-#{size}" if size

      class_names
    end

    def render_button(button)
      return render(button) if button.is_a?(ViewComponent::Base)

      render(build_button(**button))
    end

    def render_heading
      heading_size = size ? "h#{size}" : 'h1'

      content_tag(heading_size, class: heading_class_names) { label }
    end
  end
end
