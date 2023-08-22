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
    # @param options [Hash] additional options for the page.
    #
    # @option options footer_text [String] text to display in the footer, if
    #   any.
    # @option options subtitle [String] the subtitle to display.
    # @option options title [String] the title to display.
    def initialize(
      alerts:      nil,
      breadcrumbs: false,
      navigation:  false,
      **options
    )
      super()

      @alerts      = alerts
      @breadcrumbs = breadcrumbs
      @navigation  = navigation
      @options     = options
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

    # @return [Hash] additional options for the page.
    attr_reader :options

    private

    def build_alerts
      Librum::Core::View::Layouts::Page::Alerts.new(
        alerts: alerts,
        **options
      )
    end

    def build_banner
      Librum::Core::View::Layouts::Page::Banner.new(
        navigation: navigation,
        **options
      )
    end

    def build_footer
      Librum::Core::View::Layouts::Page::Footer.new(
        breadcrumbs: breadcrumbs,
        **options
      )
    end

    def render_alerts
      return if alerts.blank?

      render(build_alerts)
    end

    def render_banner
      render(build_banner)
    end

    def render_footer
      render(build_footer)
    end
  end
end
