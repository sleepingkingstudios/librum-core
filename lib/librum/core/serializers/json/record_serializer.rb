# frozen_string_literal: true

require 'cuprum/rails/serializers/json/attributes_serializer'

require 'librum/core/serializers/json'

module Librum::Core::Serializers::Json
  # Abstract base class for serializing records as JSON.
  class RecordSerializer < \
        Cuprum::Rails::Serializers::Json::AttributesSerializer
    attributes \
      :id,
      :created_at,
      :updated_at
  end
end
