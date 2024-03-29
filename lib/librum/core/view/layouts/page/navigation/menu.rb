# frozen_string_literal: true

module Librum::Core::View::Layouts
  # Renders a page navigation menu.
  class Page::Navigation::Menu < ViewComponent::Base
    # @param items [Navigation::ItemDefinition>] the navigation items to render.
    def initialize(items:)
      super()

      @items = items
    end

    # @return [Navigation::ItemDefinition>] the navigation items to render.
    attr_reader :items
  end
end
