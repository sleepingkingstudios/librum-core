# frozen_string_literal: true

require 'librum/core/view/components/page'
require 'librum/core/view/pages'

module Librum::Core::View::Pages
  # Page to display when the expected page component is not found.
  class MissingPage < Librum::Core::View::Components::Page
    # @param result [Cuprum::Result] the result of calling the controller
    #   action.
    # @param action_name [String] the name of the called action.
    # @param controller_name [String] the name of the called controller.
    # @param expected_page [String] the name of the expected page.
    def initialize(result, action_name:, controller_name:, expected_page:)
      super(result)

      @action_name     = action_name
      @controller_name = controller_name
      @expected_page   = expected_page
    end

    # @return [String] the name of the called action.
    attr_reader :action_name

    # @return [String] the name of the called controller.
    attr_reader :controller_name

    # @return [String] the name of the expected page.
    attr_reader :expected_page
  end
end
