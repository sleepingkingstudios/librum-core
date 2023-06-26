# frozen_string_literal: true

require 'librum/core/engine'
require 'librum/core/version'
require 'librum/core/railtie' if defined?(Rails::Railtie)

# The Ruby tabletop campaign companion.
module Librum
  # Librum engine defining shared functionality.
  module Core
    class << self
      # @return [Class, nil] the base authentication error.
      def authentication_error
        configuration[:authentication_error]&.constantize
      end

      # @param error_class [String] the class name of the base authentication
      #   error.
      def authentication_error=(error_class)
        configuration[:authentication_error] = error_class
      end

      # @return [Hash{Symbol=>Object}] the engine configuration.
      def configuration
        @configuration ||= {}
      end
    end
  end
end
