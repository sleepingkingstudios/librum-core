# frozen_string_literal: true

require 'cuprum/rails/controller'

module Librum::Core
  # Abstract base class for API controllers.
  class ApiController < Librum::Core::ApplicationController
    protect_from_forgery with: :null_session

    def self.serializers
      Librum::Core::Serializers::Json.default_serializers
    end

    default_format :json

    responder :json, Librum::Core::Responders::JsonResponder
  end
end
