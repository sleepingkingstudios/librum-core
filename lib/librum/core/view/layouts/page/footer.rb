# frozen_string_literal: true

module Librum::Core::View::Layouts
  # Renders the page footer.
  #
  # @todo Configurable values for the footer text.
  class Page::Footer < ViewComponent::Base
    # @param breadcrumbs [Array<Breadcrumbs::BreadcrumbConfiguration>, false]
    #   the breadcrumbs to render, or false if the page should not render
    #   breadcrumbs. Defaults to false.
    # @param footer_text [String] a text message to display in the footer, if
    #   any.
    def initialize(breadcrumbs: false, footer_text: nil, **)
      super()

      @breadcrumbs = breadcrumbs
      @footer_text = footer_text
    end

    # @return [Array<Breadcrumbs::BreadcrumbConfiguration>, false] the
    #   breadcrumbs to render, or false if the page should not render
    #   breadcrumbs.
    attr_reader :breadcrumbs

    # @return [String] a text message to display in the footer, if any.
    attr_reader :footer_text

    # @return [Boolean] true if the page has breadcrumbs or footer text;
    #   otherwise false.
    def render?
      breadcrumbs.present? || footer_text.present?
    end

    private

    def build_breadcrumbs
      Librum::Core::View::Layouts::Page::Breadcrumbs.new(
        breadcrumbs: breadcrumbs
      )
    end

    def render_breadcrumbs
      return if breadcrumbs.blank?

      render(build_breadcrumbs)
    end
  end
end
