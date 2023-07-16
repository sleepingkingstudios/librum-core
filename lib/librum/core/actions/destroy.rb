# frozen_string_literal: true

require 'cuprum/rails/actions/destroy'

module Librum::Core::Actions
  # Destroy action for generic controllers.
  class Destroy < Cuprum::Rails::Actions::Destroy
    prepend Librum::Core::Actions::FindBySlug
  end
end
