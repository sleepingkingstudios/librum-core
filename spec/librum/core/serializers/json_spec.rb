# frozen_string_literal: true

require 'rails_helper'

require 'librum/core/serializers/json'
require 'librum/core/serializers/json/date_time_serializer'

RSpec.describe Librum::Core::Serializers::Json do
  describe '.default_serializers' do
    let(:default_serializers) { described_class.default_serializers }
    let(:expected_keys) do
      [
        *Cuprum::Rails::Serializers::Json.default_serializers.keys,
        ActiveSupport::TimeWithZone,
        Date,
        DateTime,
        Time
      ]
    end

    include_examples 'should define class reader',
      :default_serializers,
      -> { an_instance_of(Hash) }

    it 'should define the default serializers' do
      expect(default_serializers.keys).to match_array(expected_keys)
    end

    it 'should include the JSON serializers' do
      expect(default_serializers)
        .to be >= Cuprum::Rails::Serializers::Json.default_serializers
    end

    it 'should define the ActiveSupport::TimeWithZone serializer' do
      expect(default_serializers[ActiveSupport::TimeWithZone])
        .to be_a Librum::Core::Serializers::Json::DateTimeSerializer
    end

    it 'should define the Date serializer' do
      expect(default_serializers[Date])
        .to be_a Librum::Core::Serializers::Json::DateTimeSerializer
    end

    it 'should define the DateTime serializer' do
      expect(default_serializers[DateTime])
        .to be_a Librum::Core::Serializers::Json::DateTimeSerializer
    end

    it 'should define the Time serializer' do
      expect(default_serializers[Time])
        .to be_a Librum::Core::Serializers::Json::DateTimeSerializer
    end
  end
end
