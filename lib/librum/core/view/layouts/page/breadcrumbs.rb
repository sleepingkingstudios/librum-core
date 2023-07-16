# frozen_string_literal: true

module Librum::Core::View::Layouts
  # Renders the page breadcrumb navigation.
  class Page::Breadcrumbs < ViewComponent::Base
    # Configuration object for a page breadcrumb.
    class BreadcrumbDefinition
      # @param label [String] the label to display for the breadcrumb.
      # @param url [String] the breadcrumb url.
      # @param active [true, false] if true, marks the breadcrumb as active and
      #   disables the link. Defaults to false.
      def initialize(label:, url:, active: false)
        @active = active
        @label  = label
        @url    = url
      end

      # @return [true, false] if true, marks the breadcrumb as active and
      #   disables the link.
      attr_reader :active

      # @return [String] the label to display for the breadcrumb.
      attr_reader :label

      # @return [String] the breadcrumb url.
      attr_reader :url
    end

    # @param breadcrumbs
    #   [Array<View::Layouts::Page::Breadcrumbs::BreadcrumbConfiguration>] the
    #   breadcrumbs to render.
    def initialize(breadcrumbs:)
      super()

      @breadcrumbs = (breadcrumbs || []).map do |breadcrumb|
        next breadcrumb if breadcrumb.is_a?(BreadcrumbDefinition)

        BreadcrumbDefinition.new(**breadcrumb)
      end
    end

    # @return [Array<View::Layouts::Page::Breadcrumbs::BreadcrumbConfiguration>]
    #   the breadcrumbs to render.
    attr_reader :breadcrumbs
  end
end
