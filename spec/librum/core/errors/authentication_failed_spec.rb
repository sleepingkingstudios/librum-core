# frozen_string_literal: true

require 'rails_helper'

require 'librum/core/errors/authentication_failed'

RSpec.describe Librum::Core::Errors::AuthenticationFailed do
  subject(:error) { described_class.new(**constructor_options) }

  let(:constructor_options) { {} }

  describe '::TYPE' do
    include_examples 'should define constant',
      :TYPE,
      'librum.core.errors.authentication_failed'
  end

  describe '.new' do
    it { expect(described_class).to be_constructible.with(0).arguments }
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
  end

  describe '#message' do
    let(:expected) { 'Unable to authenticate request' }

    include_examples 'should define reader', :message, -> { be == expected }
  end

  describe '#type' do
    include_examples 'should define reader', :type, described_class::TYPE
  end
end
