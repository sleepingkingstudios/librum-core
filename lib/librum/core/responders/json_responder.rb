# frozen_string_literal: true

require 'cuprum/collections/errors/failed_validation'
require 'cuprum/collections/errors/not_found'
require 'cuprum/collections/errors/not_unique'
require 'cuprum/rails/responders/json_responder'

require 'librum/core/errors/authentication_error'
require 'librum/core/errors/authentication_failed'
require 'librum/core/responders'

module Librum::Core::Responders
  # Base class for generating JSON responses.
  class JsonResponder < Cuprum::Rails::Responders::JsonResponder
    BASE_AUTHENTICATION_ERROR =
      Rails.application.config.librum_core.authentication_error.constantize
    private_constant :BASE_AUTHENTICATION_ERROR

    match :failure, error: Cuprum::Collections::Errors::FailedValidation \
    do |result|
      render_failure(result.error, status: 422)
    end

    match :failure, error: Cuprum::Collections::Errors::NotFound do |result|
      render_failure(result.error, status: 404)
    end

    match :failure, error: Cuprum::Collections::Errors::NotUnique do |result|
      render_failure(result.error, status: 404)
    end

    match :failure, error: Cuprum::Rails::Errors::InvalidParameters do |result|
      render_failure(result.error, status: 400)
    end

    match :failure, error: BASE_AUTHENTICATION_ERROR do |result|
      render_failure(
        Rails.env.development? ? result.error : authentication_error,
        status: 401
      )
    end

    def authentication_error
      Librum::Core::Errors::AuthenticationFailed.new
    end
  end
end
