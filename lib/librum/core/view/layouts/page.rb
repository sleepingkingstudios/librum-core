# frozen_string_literal: true

module Librum::Core::View::Layouts
  # Default layout for server-side rendered pages.
  class Page < ViewComponent::Base
    # @param alerts [Hash{String=>String}] the alerts to display.
    # @param breadcrumbs [Array<Breadcrumbs::BreadcrumbConfiguration>, false]
    #   the breadcrumbs to render, or false if the page should not render
    #   breadcrumbs. Defaults to false.
    # @param navigation [Navigation::Configuration, false] the configured
    #   navigation, or false if the navigation bar is hidden. Defaults to false.
    def initialize(
      alerts:      nil,
      breadcrumbs: false,
      navigation:  false,
      **
    )
      super()

      @alerts      = alerts
      @breadcrumbs = breadcrumbs
      @navigation  = navigation
    end

    renders_one :after_content

    renders_one :before_content

    # @return [Hash{String=>String}] the alerts to display.
    attr_reader :alerts

    # @return [Array<Breadcrumbs::BreadcrumbConfiguration>, false] the
    #   breadcrumbs to render, or false if the page should not render
    #   breadcrumbs.
    attr_reader :breadcrumbs

    # @return [Navigation::Configuration, false] the configured navigation, or
    #   false if the navigation bar is hidden.
    attr_reader :navigation
  end
end
