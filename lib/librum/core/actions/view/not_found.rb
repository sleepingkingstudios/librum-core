# frozen_string_literal: true

module Librum::Core::Actions::View
  # Action that renders a NotFound page.
  class NotFound < Cuprum::Rails::Action
    private

    def process(**)
      super

      Librum::Core::View::Components::NotFound.new
    end
  end
end
