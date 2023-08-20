# frozen_string_literal: true

module Librum::Core::View::Layouts
  # Renders the page banner and navigation.
  #
  # @todo Configurable values for the :title, :subtitle text.
  class Page::Banner < ViewComponent::Base
    # @param navigation [Navigation::Configuration, false] the configured
    #   navigation, or false if the navigation bar is hidden.
    # @param subtitle [String] the subtitle to display.
    # @param title [String] the title to display.
    def initialize(navigation: false, subtitle: nil, title: nil, **)
      super()

      @navigation = navigation
      @subtitle   = subtitle
      @title      = title
    end

    # @return [Navigation::Configuration, false] the configured navigation, or
    #   false if the navigation bar is hidden.
    attr_reader :navigation

    # @return [String] the subtitle to display.
    attr_reader :subtitle

    # @return [String] the title to display.
    attr_reader :title

    # @return [Boolean] true if the page has navigation or a title; otherwise
    #   false.
    def render?
      title.present? || navigation.present?
    end
  end
end
