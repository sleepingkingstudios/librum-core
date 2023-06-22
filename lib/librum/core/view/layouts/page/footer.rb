# frozen_string_literal: true

require 'librum/core/view/layouts/page'
require 'librum/core/view/layouts/page/breadcrumbs'

module Librum::Core::View::Layouts
  # Renders the page footer.
  #
  # @todo Configurable values for the footer text.
  class Page::Footer < ViewComponent::Base
    # @param breadcrumbs [Array<Breadcrumbs::BreadcrumbConfiguration>, false]
    #   the breadcrumbs to render, or false if the page should not render
    #   breadcrumbs. Defaults to false.
    def initialize(breadcrumbs: false)
      super()

      @breadcrumbs = breadcrumbs
    end

    # @return [Array<Breadcrumbs::BreadcrumbConfiguration>, false] the
    #   breadcrumbs to render, or false if the page should not render
    #   breadcrumbs.
    attr_reader :breadcrumbs
  end
end
