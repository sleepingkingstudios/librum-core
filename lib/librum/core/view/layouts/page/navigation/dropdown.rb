# frozen_string_literal: true

require 'librum/core/view/components/link'
require 'librum/core/view/layouts/page/navigation'

module Librum::Core::View::Layouts
  # Renders a page navigation dropdown.
  class Page::Navigation::Dropdown < ViewComponent::Base
    # @param items [Array<Navigation::ItemDefinition>] the navigation items to
    #   render in the dropdown.
    def initialize(items:)
      super()

      @items = items
    end

    # @return [Array<Navigation::ItemDefinition>] the navigation items to render
    #   in the dropdown.
    attr_reader :items
  end
end
