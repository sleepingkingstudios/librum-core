# frozen_string_literal: true

module Librum::Core::View::Layouts
  # Renders a page navigation item.
  class Page::Navigation::Item < ViewComponent::Base
    extend Forwardable

    # @param item [Navigation::ItemDefinition] the navigation item to render.
    def initialize(item:)
      super()

      @item = item
    end

    def_delegators :@item,
      :items,
      :label,
      :url

    # @return [Navigation::ItemDefinition] the navigation item to render.
    attr_reader :item

    private

    def dropdown?
      items.present?
    end
  end
end
