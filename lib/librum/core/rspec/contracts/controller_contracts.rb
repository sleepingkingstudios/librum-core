# frozen_string_literal: true

require 'rspec/sleeping_king_studios/contract'

module Librum::Core::RSpec::Contracts
  module ControllerContracts
    # Contract asserting the controller defines the specified action.
    module ShouldDefineAction
      extend RSpec::SleepingKingStudios::Contract

      contract do |action_name, action_class, member: false|
        # :nocov:
        describe "##{action_name}" do
          subject(:action) { described_class.actions[action_name.intern] }

          it { expect(described_class.actions).to have_key(action_name.intern) }

          it { expect(action.action_class).to be action_class }

          it { expect(action.member_action?).to be member }
        end
        # :nocov:
      end
    end

    # Contract asserting the controller includes the middleware with options.
    module ShouldDefineMiddleware
      extend RSpec::SleepingKingStudios::Contract

      contract do |expected, except: [], only: []|
        # :nocov:
        describe '.middleware' do
          let(:middleware) do
            described_class
              .middleware
              .find { |config| match_middleware(expected, config) }
          end

          def match_middleware(expected, actual)
            expected = instance_exec(&expected) if expected.is_a?(Proc)

            if expected.is_a?(Class)
              return true if actual.command == expected
              return true if actual.command.is_a?(expected)
            end

            if expected.respond_to?(:matches?)
              return expected.matches?(actual.command)
            end

            actual.command == expected
          end

          it 'should define the middleware' do
            expect(described_class.middleware).to include(
              satisfy { |actual| match_middleware(expected, actual) }
            )
          end

          it { expect(middleware.except.to_a).to be == except }

          it { expect(middleware.only.to_a).to be == only }
        end
        # :nocov:
      end
    end

    # Contract asserting the controller does not respond to the given format.
    module ShouldNotRespondToFormatContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |format|
        it { expect(described_class.responders[format]).to be nil }
      end
    end

    # Contract asserting the controller responds to the given format.
    module ShouldRespondToFormatContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |format, using:|
        # :nocov:
        it { expect(described_class.responders[format]).to be == using }
        # :nocov:
      end
    end

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
