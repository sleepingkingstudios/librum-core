# frozen_string_literal: true

require 'cuprum'

module Librum::Core::Errors
  # Abstract error class used for testing responders.
  class AuthenticationError < Cuprum::Error
    # Short string used to identify the type of error.
    TYPE = 'librum.core.errors.authentication_error'
  end
end
