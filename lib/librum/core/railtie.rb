# frozen_string_literal: true

require 'librum/core'

module Librum::Core
  # Handles Rails configuration and initializers.
  class Railtie < Rails::Railtie
    config.librum_core = Rails::Railtie::Configuration.new.tap do |core|
      core.authentication_error = 'Librum::Core::Errors::AuthenticationError'
    end
  end
end
