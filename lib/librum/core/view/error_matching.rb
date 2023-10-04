# frozen_string_literal: true

require 'stannum/errors'

module Librum::Core::View
  # Mixin for extracting matching error messages from an errors object.
  module ErrorMatching
    # @return [Array<String>] the error messages for the component name.
    def matching_errors
      @matching_errors ||= find_matching_errors
    end

    private

    def find_errors_with_brackets
      errors
        .dig(*error_key.gsub(']', '')
        .split('['))
        .map { |err| err[:message] } # rubocop:disable Rails/Pluck
    end

    def find_errors_with_periods
      errors
        .dig(*error_key.split('.'))
        .map { |err| err[:message] } # rubocop:disable Rails/Pluck
    end

    def find_matching_errors
      return errors if errors.is_a?(Array)

      return find_stannum_errors if errors.is_a?(Stannum::Errors)

      []
    end

    def find_stannum_errors
      matching = errors[error_key].map { |err| err[:message] } # rubocop:disable Rails/Pluck

      if error_key.include?('.')
        matching += find_errors_with_periods
      elsif error_key.include?('[')
        matching += find_errors_with_brackets
      end

      matching.uniq
    end
  end
end
