# frozen_string_literal: true

require 'librum/core/rspec/contracts'

require 'rspec/sleeping_king_studios/contract'

module Librum::Core::RSpec::Contracts
  module SerializerContracts
    # Contract asserting that the serializer serializes the object's attributes.
    module ShouldSerializeAttributesContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |object, *attr_names, **attr_pairs|
        describe '#call' do
          let(:configured_object) do
            # :nocov:
            if object.is_a?(Proc)
              instance_exec(&object)
            else
              object
            end
            # :nocov:
          end
          let(:configured_serializers) do
            Librum::Core::Serializers::Json.default_serializers
          end
          let(:configured_context) do
            Cuprum::Rails::Serializers::Context
              .new(serializers: configured_serializers)
          end
          let(:expected) do
            values = {}

            # :nocov:
            attr_names.each do |attr_name|
              raw_value = configured_object.attributes.fetch(attr_name.to_s) do
                configured_object.send(attr_name.intern)
              end

              values[attr_name.to_s] = configured_context.serialize(raw_value)
            end

            attr_pairs.each do |attr_name, attr_value|
              expected_value =
                attr_value.is_a?(Proc) ? instance_exec(&attr_value) : attr_value

              values[attr_name.to_s] = expected_value
            end
            # :nocov:

            values
          end

          it 'should define the method' do
            expect(serializer)
              .to respond_to(:call)
              .with(1).argument
              .and_keywords(:context)
          end

          it 'should serialize the attributes' do
            expect(
              serializer.call(configured_object, context: configured_context)
            ).to deep_match expected
          end
        end
      end
    end

    # Contract asserting that the serializer serializes the record's attributes.
    module ShouldSerializeRecordAttributesContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |object, *attr_names, **attr_pairs|
        include Librum::Core::RSpec::Contracts::SerializerContracts

        include_contract 'should serialize attributes',
          object,
          :id,
          *attr_names,
          :created_at,
          :updated_at,
          **attr_pairs
      end
    end
  end
end
