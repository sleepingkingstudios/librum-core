# frozen_string_literal: true

module Librum::Core::Actions
  # Show action for generic controllers.
  class Update < Cuprum::Rails::Actions::Update
    prepend Librum::Core::Actions::FindBySlug
    prepend Librum::Core::Actions::GenerateSlug
  end
end
