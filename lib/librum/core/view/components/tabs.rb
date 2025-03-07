# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders a bar of navigational tabs.
  class Tabs < ViewComponent::Base
    # Data object representing configuration for a tab.
    class TabDefinition
      include Librum::Core::View::Options
      include Librum::Core::View::ClassName

      # @param key [String] a unique identifier for the tab.
      # @param options [Hash] additional options for the tab.
      #
      # @option options color [String] the color of the rendered tab.
      # @option options default [Boolean] if true, the tab is rendered as
      #   active if no tab is specified.
      # @option options icon [String] the name of the icon, if any, to display.
      # @option options label [String] the label used when rendering the tab.
      # @option options url [String] the url for the tab link, if any.
      def initialize(key:, **)
        super(**)

        @key   = key
        @label = label || key.titleize
      end

      option :color

      option :default, boolean: true

      option :icon

      option :label, default: -> { key.titleize }

      option :url

      # @return [String] a unique identifier for the tab.
      attr_reader :key

      # @return [Boolean] true if the tab has an icon; otherwise false.
      def icon?
        icon.present?
      end

      # @return [Boolean] true if the tab is a link; otherwise false.
      def link?
        url.present?
      end
    end

    # @param tabs [Array<TabDefinition, Hash>] the tabs to render.
    # @param active [String, Symbol] the key of the currently active tab.
    def initialize(tabs:, active: nil)
      super()

      @tabs = tabs.map do |tab|
        next tab unless tab.is_a?(Hash)

        Librum::Core::View::Components::Tabs::TabDefinition.new(**tab)
      end
      @active = active || @tabs.find(&:default?)&.key
    end

    # @return [String, Symbol] the key of the currently active tab.
    attr_reader :active

    # @return [Array<TabDefinition>] the tabs to render.
    attr_reader :tabs

    private

    def build_tab(tab)
      Librum::Core::View::Components::Tabs::Item.new(
        tab:    tab,
        active: tab.key == active
      )
    end

    def render_tab(tab)
      render(build_tab(tab))
    end
  end
end
