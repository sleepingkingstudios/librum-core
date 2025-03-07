# frozen_string_literal: true

module Librum::Core::Actions::View::Middleware
  # Middleware for configuring a view page's breadcrumbs.
  class PageBreadcrumbs <
        Librum::Core::Actions::View::Middleware::PageConfiguration
    # @param breadcrumbs [Array<Page::Breadcrumbs::BreadcrumbConfiguration>] the
    #   breadcrumbs to render.
    # @param options [Hash{Symbol=>Object}] additional options for configuring
    #   the view page.
    def initialize(breadcrumbs:, **)
      super(**)

      @breadcrumbs = breadcrumbs
    end

    # @return [Array<Page::Breadcrumbs::BreadcrumbConfiguration>] the
    #   breadcrumbs to render.
    attr_reader :breadcrumbs

    private

    def page_metadata
      { breadcrumbs: breadcrumbs }
    end
  end
end
