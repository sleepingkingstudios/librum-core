# frozen_string_literal: true

module Librum::Core::Errors
  # Generic error returned for a request that fails authentication.
  class AuthenticationFailed < Librum::Core::Errors::AuthenticationError
    # Short string used to identify the type of error.
    TYPE = 'librum.core.errors.authentication_failed'

    def initialize
      super(message: 'Unable to authenticate request')
    end
  end
end
