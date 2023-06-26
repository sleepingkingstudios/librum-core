# frozen_string_literal: true

require 'cuprum/rails/controller'

require 'librum/core/responders/json_responder'
require 'librum/core/serializers/json'

module Librum::Core
  # Abstract base class for API controllers.
  class ApiController < Librum::Core::ApplicationController
    include Cuprum::Rails::Controller

    protect_from_forgery with: :null_session

    def self.repository
      @repository ||= Cuprum::Rails::Repository.new
    end

    def self.serializers
      Librum::Core::Serializers::Json.default_serializers
    end

    default_format :json

    responder :json, Librum::Core::Responders::JsonResponder
  end
end
