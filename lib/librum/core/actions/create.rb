# frozen_string_literal: true

require 'librum/core/actions'
require 'librum/core/actions/generate_slug'

module Librum::Core::Actions
  # Create action for generic controllers.
  class Create < Cuprum::Rails::Actions::Create
    prepend Librum::Core::Actions::GenerateSlug
  end
end
