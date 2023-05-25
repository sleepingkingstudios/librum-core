# frozen_string_literal: true

require 'cuprum/rails/serializers/base_serializer'

require 'librum/core/serializers/json'

module Librum::Core::Serializers::Json
  # Serializer that returns a date or time object's ISO8601 representation.
  class DateTimeSerializer < Cuprum::Rails::Serializers::BaseSerializer
    # Returns the ISO8601 representation.
    #
    # This serializer should only be used with date or time objects.
    #
    # @param object [Object] The object to convert to JSON.
    #
    # @return [Object] a JSON representation of the object.
    def call(object, **_)
      object&.iso8601
    end
  end
end
