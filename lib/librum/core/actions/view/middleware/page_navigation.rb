# frozen_string_literal: true

module Librum::Core::Actions::View::Middleware
  # Middleware for configuring a view page's navigation.
  class PageNavigation <
        Librum::Core::Actions::View::Middleware::PageConfiguration
    include Cuprum::Middleware

    # @param navigation [Page::Navigation::Configuration] the navigation to
    #   render.
    # @param options [Hash{Symbol=>Object}] additional options for configuring
    #   the view page.
    def initialize(navigation: nil, **)
      super(**)

      @navigation = navigation
    end

    # @return [Page::Navigation::Configuration] the navigation to render.
    attr_reader :navigation

    private

    def page_metadata
      { navigation: navigation }
    end
  end
end
