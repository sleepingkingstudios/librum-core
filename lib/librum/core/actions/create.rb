# frozen_string_literal: true

module Librum::Core::Actions
  # Create action for generic controllers.
  class Create < Cuprum::Rails::Actions::Create
    prepend Librum::Core::Actions::GenerateSlug
  end
end
