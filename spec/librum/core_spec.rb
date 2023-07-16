# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/error'

RSpec.describe Librum::Core do
  let(:expected_configuration) { {} }

  around(:example) do |example|
    previous = described_class.configuration.dup

    described_class.configuration.clear

    example.call
  ensure
    described_class.configuration.clear.update(previous)
  end

  describe '.authentication_error' do
    include_examples 'should define class reader',
      :authentication_error,
      nil

    context 'when the engine has a set authentication error' do
      example_class 'Spec::AuthenticationError', Cuprum::Error

      before(:example) do
        described_class.authentication_error = 'Spec::AuthenticationError'
      end

      it 'should return the error class' do
        expect(described_class.authentication_error)
          .to be Spec::AuthenticationError
      end
    end
  end

  describe '.authentication_error=' do
    include_examples 'should define class writer',
      :authentication_error=

    example_class 'Spec::CustomError', Cuprum::Error

    it 'should update the error class' do
      expect { described_class.authentication_error = 'Spec::CustomError' }
        .to change(described_class, :authentication_error)
        .to be Spec::CustomError
    end

    context 'when the engine has a set authentication error' do
      example_class 'Spec::AuthenticationError', Cuprum::Error

      before(:example) do
        described_class.authentication_error = 'Spec::AuthenticationError'
      end

      it 'should update the error class' do
        expect { described_class.authentication_error = 'Spec::CustomError' }
          .to change(described_class, :authentication_error)
          .to be Spec::CustomError
      end
    end
  end

  describe '.configuration' do
    include_examples 'should define class reader',
      :configuration,
      -> { be == expected_configuration }

    context 'when the engine has custom configuration' do
      let(:expected_configuration) do
        super().merge(custom_key: 'custom value')
      end

      before(:example) do
        described_class.configuration[:custom_key] = 'custom value'
      end

      it 'should return the configuration' do
        expect(described_class.configuration).to be == expected_configuration
      end
    end

    context 'when the engine has a set authentication error' do
      let(:expected_configuration) do
        super().merge(authentication_error: 'Spec::AuthenticationError')
      end

      example_class 'Spec::AuthenticationError', Cuprum::Error

      before(:example) do
        described_class.authentication_error = 'Spec::AuthenticationError'
      end

      it 'should return the configuration' do
        expect(described_class.configuration).to be == expected_configuration
      end
    end
  end
end
