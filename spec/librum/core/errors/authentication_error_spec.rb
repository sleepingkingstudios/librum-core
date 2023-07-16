# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::Errors::AuthenticationError do
  subject(:error) { described_class.new(**constructor_options) }

  let(:message)             { 'User not authorized' }
  let(:constructor_options) { { message: message } }

  describe '::TYPE' do
    include_examples 'should define constant',
      :TYPE,
      'librum.core.errors.authentication_error'
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:message, :type)
        .and_any_keywords
    end
  end

  describe '#as_json' do
    let(:expected) do
      {
        'data'    => {},
        'message' => error.message,
        'type'    => error.type
      }
    end

    it { expect(error.as_json).to be == expected }

    context 'when initialized with data' do
      let(:constructor_options) do
        super().merge(
          username: 'Alan Bradley',
          password: 'tronlives'
        )
      end

      it { expect(error.as_json).to be == expected }
    end

    context 'when initialized with type: value' do
      let(:type)                { 'spec.errors.example_error' }
      let(:constructor_options) { super().merge(type: type) }
      let(:expected)            { super().merge('type' => type) }

      it { expect(error.as_json).to be == expected }
    end
  end

  describe '#message' do
    include_examples 'should define reader', :message, -> { be == message }
  end

  describe '#type' do
    include_examples 'should define reader', :type, described_class::TYPE

    context 'when initialized with type: value' do
      let(:type)                { 'spec.errors.example_error' }
      let(:constructor_options) { super().merge(type: type) }

      it { expect(error.type).to be == type }
    end
  end
end
