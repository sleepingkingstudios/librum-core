# frozen_string_literal: true

require 'librum/core/actions'
require 'librum/core/actions/find_by_slug'

module Librum::Core::Actions
  # Show action for generic controllers.
  class Show < Cuprum::Rails::Actions::Show
    prepend Librum::Core::Actions::FindBySlug
  end
end
