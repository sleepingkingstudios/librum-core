# frozen_string_literal: true

module Librum::Core::Actions
  # Show action for generic controllers.
  class Show < Cuprum::Rails::Actions::Show
    prepend Librum::Core::Actions::FindBySlug
  end
end
