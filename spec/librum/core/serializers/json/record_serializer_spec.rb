# frozen_string_literal: true

require 'librum/core/rspec/contracts/serializer_contracts'
require 'librum/core/serializers/json/record_serializer'

require 'rails_helper'

RSpec.describe Librum::Core::Serializers::Json::RecordSerializer do
  include Librum::Core::RSpec::Contracts::SerializerContracts

  subject(:serializer) { described_class.new }

  let(:record) do
    Spec::ExampleRecord.new(
      id:         '00000000-0000-0000-0000-000000000000',
      created_at: 1.day.ago,
      updated_at: 1.hour.ago,
      name:       'Self-sealing Stem Bolt',
      type:       'Quality Merchandise'
    )
  end

  example_class 'Spec::ExampleRecord',
    Struct.new(
      :id,
      :created_at,
      :updated_at,
      :name,
      :type,
      keyword_init: true
    ) {
      def attributes
        to_h
      end
    }

  describe '::new' do
    it { expect(described_class).to be_constructible.with(0).arguments }
  end

  include_contract 'should serialize attributes',
    -> { record },
    :id,
    :created_at,
    :updated_at

  include_contract 'should serialize record attributes',
    -> { record }

  context 'with a serializer subclass' do
    let(:described_class) { Spec::ExampleSerializer }

    # rubocop:disable RSpec/DescribedClass
    example_class 'Spec::ExampleSerializer',
      Librum::Core::Serializers::Json::RecordSerializer \
    do |klass|
      klass.attributes \
        :name,
        :type
    end
    # rubocop:enable RSpec/DescribedClass

    include_contract 'should serialize attributes',
      -> { record },
      :id,
      :created_at,
      :updated_at,
      :name,
      :type

    include_contract 'should serialize record attributes',
      -> { record },
      :name,
      :type
  end
end
