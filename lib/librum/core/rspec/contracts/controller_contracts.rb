# frozen_string_literal: true

require 'rspec/sleeping_king_studios/contract'

module Librum::Core::RSpec::Contracts
  module ControllerContracts
    # Contract asserting the controller serializes the given type.
    module ShouldSerializeContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |klass, using:|
        # :nocov:
        it { expect(described_class.serializers[klass]).to be == using }
        # :nocov:
      end
    end

    # Contract asserting the controller serializes the default types.
    module ShouldUseTheDefaultSerializers
      extend RSpec::SleepingKingStudios::Contract

      contract do
        let(:expected) do
          Librum::Core::Serializers::Json.default_serializers
        end

        it 'should use the default attribute serializers' do
          expect(described_class.serializers).to be >= expected
        end
      end
    end
  end
end
