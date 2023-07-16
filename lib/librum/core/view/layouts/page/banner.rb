# frozen_string_literal: true

module Librum::Core::View::Layouts
  # Renders the page banner and navigation.
  #
  # @todo Configurable values for the :title, :subtitle text.
  class Page::Banner < ViewComponent::Base
    # @param navigation [Navigation::Configuration, false] the configured
    #   navigation, or false if the navigation bar is hidden.
    def initialize(navigation: false, **)
      super()

      @navigation = navigation
    end

    # @return [Navigation::Configuration, false] the configured navigation, or
    #   false if the navigation bar is hidden.
    attr_reader :navigation
  end
end
