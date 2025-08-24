# frozen_string_literal: true

module Librum::Core::Actions
  # Finds and updates an entity by ID or slug with optional generated slug.
  class Update < Cuprum::Rails::Actions::Update
    prepend Librum::Core::Actions::FindBySlug
    prepend Librum::Core::Actions::GenerateSlug
  end
end
