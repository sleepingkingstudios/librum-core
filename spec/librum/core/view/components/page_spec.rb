# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::Page do
  subject(:page) { described_class.new(result, **constructor_options) }

  let(:result)              { Cuprum::Result.new }
  let(:constructor_options) { {} }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(1).argument
        .and_keywords(:resource)
        .and_any_keywords
    end
  end

  describe '#error' do
    include_examples 'should define reader', :error, nil

    context 'when initialized with a result with an error' do
      let(:error)  { Cuprum::Error.new(message: 'Something went wrong') }
      let(:result) { Cuprum::Result.new(error: error) }

      it { expect(page.error).to be error }
    end
  end

  describe '#metadata' do
    include_examples 'should define reader', :metadata, nil

    context 'when initialized with a result with metadata' do
      let(:metadata) { { session: { token: '12345' } } }
      let(:result)   { Cuprum::Rails::Result.new(metadata: metadata) }

      it { expect(page.metadata).to be == metadata }
    end
  end

  describe '#options' do
    include_examples 'should define reader', :options, {}

    context 'when initialized with options' do
      let(:constructor_options) { { key: 'value' } }

      it { expect(page.options).to be == constructor_options }
    end
  end

  describe '#resource' do
    include_examples 'should define reader', :resource, {}

    context 'when initialized with resource: value' do
      let(:resource) { Cuprum::Rails::Resource.new(resource_name: 'rockets') }
      let(:constructor_options) do
        super().merge(resource: resource)
      end

      it { expect(page.resource).to be resource }
    end
  end

  describe '#result' do
    include_examples 'should define reader', :result, -> { result }
  end

  describe '#status' do
    include_examples 'should define reader', :status, :success

    context 'when initialized with a result with status: :failure' do
      let(:result) { Cuprum::Result.new(status: :failure) }

      it { expect(page.status).to be :failure }
    end

    context 'when initialized with a result with status: :success' do
      let(:result) { Cuprum::Result.new(status: :success) }

      it { expect(page.status).to be :success }
    end
  end

  describe '#value' do
    include_examples 'should define reader', :value, nil

    context 'when initialized with a result with a value' do
      let(:value)  { { ok: true } }
      let(:result) { Cuprum::Result.new(value: value) }

      it { expect(page.value).to be value }
    end
  end
end
