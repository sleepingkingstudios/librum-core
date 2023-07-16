# frozen_string_literal: true

module Librum::Core::View::Layouts
  # Renders the page navigation.
  class Page::Navigation < ViewComponent::Base
    # Configuration object for page navigation.
    class Configuration
      # @param icon [String, nil] the icon to display in the brand link.
      # @param items [Array<ItemDefinition>] the navigation items to display.
      # @param label [String, nil] the label to display in the brand link.
      # @param url [String] the url for the brand link. Defaults to '/'.
      def initialize(icon: nil, items: nil, label: nil, url: '/')
        @icon  = icon
        @items = (items || []).map do |item|
          next item unless item.is_a?(Hash)

          Librum::Core::View::Layouts::Page::Navigation::ItemDefinition
            .new(**item)
        end
        @label = label
        @url   = url
      end

      # @return [String, nil] the icon to display in the brand link.
      attr_reader :icon

      # @return [Array<ItemDefinition>] the navigation items to display.
      attr_reader :items

      # @return [String, nil] the label to display in the brand link.
      attr_reader :label

      # @return [String] the url for the brand link.
      attr_reader :url
    end

    # Configuration object for a page navigation item.
    class ItemDefinition
      # @param label [String] the label to render.
      # @param align [:left, :right] the alignment of the item in the menu.
      # @param url [String] the link url to render.
      # @param items [Array<ItemDefinition>] the child items to display in a
      #   dropdown menu.
      def initialize(label:, url:, align: :left, items: nil)
        @items = (items || []).map do |item|
          item.is_a?(self.class) ? item : self.class.new(**item)
        end
        @align = align
        @label = label
        @url   = url
      end

      # @return [:left, :right] the alignment of the item in the menu.
      attr_reader :align

      # @return [Array<ItemDefinition>] the child items to display in a dropdown
      #   menu.
      attr_reader :items

      # @return [String] the label to render.
      attr_reader :label

      # @return [String] the link url to render.
      attr_reader :url

      # @return [Boolean] true if the item has dropdown items, otherwise false.
      def dropdown?
        @items.present?
      end

      # @return [Boolean] true if the item should be rendered to the left.
      def left?
        @align == :left
      end

      # @return [Boolean] true if the item should be rendered to the right.
      def right?
        @align == :right
      end
    end

    # @param config [Navigation::Configuration] the config for the page
    #   navigation.
    def initialize(config:)
      super()

      @config =
        if config.is_a?(Configuration)
          config
        else
          Configuration.new(**config)
        end
    end

    # @return [Navigation::Configuration] the config for the page navigation.
    attr_reader :config
  end
end
