# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/rspec/deferred/responder_examples'
require 'stannum'

require 'support/models/rocket'

RSpec.describe Librum::Core::Responders::JsonResponder do
  include Cuprum::Rails::RSpec::Deferred::ResponderExamples
  include Librum::Core::RSpec::Contracts::Responders::JsonContracts

  subject(:responder) { described_class.new(**constructor_options) }

  let(:member_action)    { true }
  let(:resource_options) { { name: 'rockets' } }
  let(:constructor_options) do
    {
      action_name:   action_name,
      controller:    controller,
      member_action: member_action,
      request:       request,
      serializers:   Librum::Core::Serializers::Json.default_serializers
    }
  end

  include_deferred 'should implement the Responder methods',
    constructor_keywords: %i[serializers]

  describe '#call' do
    describe 'with a passing result' do
      let(:result) { Cuprum::Result.new(value: { 'key' => 'value' }) }

      include_contract 'should respond with json', 200 do
        { 'ok' => true, 'data' => result.value }
      end
    end

    describe 'with a failing result' do
      let(:error)  { Cuprum::Error.new(message: 'Something went wrong') }
      let(:result) { Cuprum::Result.new(error: error) }
      let(:expected_error) do
        {
          'data'    => {},
          'message' => 'Something went wrong when processing the request',
          'type'    => 'cuprum.error'
        }
      end

      include_contract 'should respond with json', 500 do
        { 'ok' => false, 'error' => expected_error }
      end
    end

    describe 'with a failing result with a FailedValidation error' do
      let(:error) do
        Cuprum::Collections::Errors::FailedValidation.new(
          entity_class: Rocket,
          errors:       Stannum::Errors.new
        )
      end
      let(:result) { Cuprum::Result.new(error: error) }

      include_contract 'should respond with json', 422 do
        { 'ok' => false, 'error' => result.error.as_json }
      end
    end

    describe 'with a failing result with a NotFound error' do
      let(:error) do
        Cuprum::Collections::Errors::NotFound.new(
          attributes:      { 'name' => 'SLS' },
          collection_name: 'rockets'
        )
      end
      let(:result) { Cuprum::Result.new(error: error) }

      include_contract 'should respond with json', 404 do
        { 'ok' => false, 'error' => result.error.as_json }
      end
    end

    describe 'with a failing result with a NotUnique error' do
      let(:error) do
        Cuprum::Collections::Errors::NotUnique.new(
          attributes:      { 'name' => 'Falcon' },
          collection_name: 'rockets'
        )
      end
      let(:result) { Cuprum::Result.new(error: error) }

      include_contract 'should respond with json', 404 do
        { 'ok' => false, 'error' => result.error.as_json }
      end
    end

    describe 'with a failing result with an Authentication error' do
      let(:error) do
        Librum::Core::Errors::AuthenticationError.new(
          message: 'Something went wrong'
        )
      end
      let(:result) { Cuprum::Result.new(error: error) }
      let(:expected_error) do
        Librum::Core::Errors::AuthenticationFailed.new
      end

      include_contract 'should respond with json', 401 do
        { 'ok' => false, 'error' => expected_error.as_json }
      end

      context 'when the Rails environment is development' do
        before(:example) do
          allow(Rails.env).to receive(:development?).and_return(true)
        end

        include_contract 'should respond with json', 401 do
          { 'ok' => false, 'error' => result.error.as_json }
        end
      end
    end

    describe 'with a failing result with an InvalidParameters error' do
      let(:error) do
        errors = Stannum::Errors.new

        Cuprum::Rails::Errors::InvalidParameters.new(errors: errors)
      end
      let(:result) { Cuprum::Result.new(error: error) }

      include_contract 'should respond with json', 400 do
        { 'ok' => false, 'error' => error.as_json }
      end
    end
  end
end
