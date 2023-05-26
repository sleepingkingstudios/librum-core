# frozen_string_literal: true

require 'librum/core/actions'
require 'librum/core/actions/find_by_slug'
require 'librum/core/actions/generate_slug'

module Librum::Core::Actions
  # Show action for generic controllers.
  class Update < Cuprum::Rails::Actions::Update
    prepend Librum::Core::Actions::FindBySlug
    prepend Librum::Core::Actions::GenerateSlug
  end
end
