# frozen_string_literal: true

require 'librum/core/view/components/link'
require 'librum/core/view/layouts/page/navigation'

module Librum::Core::View::Layouts
  # Renders the navigation brand icon or image.
  class Page::Navigation::Brand < ViewComponent::Base
    extend Forwardable

    # @param config [Navigation::Configuration] the config for the page
    #   navigation.
    def initialize(config:)
      super()

      @config = config
    end

    # @return [Navigation::Configuration] the config for the page navigation.
    attr_reader :config

    def_delegators :@config,
      :icon,
      :label,
      :url
  end
end
