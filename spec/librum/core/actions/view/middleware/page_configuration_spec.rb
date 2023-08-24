# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::Actions::View::Middleware::PageConfiguration do
  subject(:middleware) { described_class.new(**options) }

  let(:options) { {} }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_any_keywords
    end
  end

  describe '#call' do
    let(:next_result)   { Cuprum::Result.new(value: { 'ok' => true }) }
    let(:next_command)  { instance_double(Cuprum::Command, call: next_result) }
    let(:request)       { Cuprum::Rails::Request.new }
    let(:options)       { { custom_option: 'custom value' } }

    it 'should call the next command' do
      middleware.call(next_command, request: request, **options)

      expect(next_command)
        .to have_received(:call)
        .with(request: request, **options)
    end

    it 'should return a passing result' do
      expect(middleware.call(next_command, request: request))
        .to be_a_passing_result(Cuprum::Rails::Result)
        .with_value(next_result.value)
        .and_error(next_result.error)
        .and_metadata({ page: {} })
    end

    describe 'with a failing result' do
      let(:error)       { Cuprum::Error.new(message: 'Something went wrong') }
      let(:next_result) { Cuprum::Result.new(error: error) }

      it 'should return a failing result' do
        expect(middleware.call(next_command, request: request))
          .to be_a_failing_result(Cuprum::Rails::Result)
          .with_value(next_result.value)
          .and_error(next_result.error)
          .and_metadata({ page: {} })
      end
    end

    describe 'with a rails result' do
      let(:next_result) do
        Cuprum::Rails::Result.new(value: { 'ok' => true })
      end

      it 'should return a passing result' do
        expect(middleware.call(next_command, request: request))
          .to be_a_passing_result(Cuprum::Rails::Result)
          .with_value(next_result.value)
          .and_error(next_result.error)
          .and_metadata({ page: {} })
      end
    end

    describe 'with a rails result with metadata' do
      let(:metadata) do
        { session: { token: '12345' } }
      end
      let(:next_result) do
        Cuprum::Rails::Result.new(value: { 'ok' => true }, metadata: metadata)
      end
      let(:expected_metadata) { metadata.merge(page: {}) }

      it 'should return a passing result' do
        expect(middleware.call(next_command, request: request))
          .to be_a_passing_result(Cuprum::Rails::Result)
          .with_value(next_result.value)
          .and_error(next_result.error)
          .and_metadata(expected_metadata)
      end
    end

    describe 'with a rails result with page metadata' do
      let(:metadata) do
        {
          page:    {
            breadcrumbs: [{ label: 'Home', url: '/' }]
          },
          session: { token: '12345' }
        }
      end
      let(:next_result) do
        Cuprum::Rails::Result.new(value: { 'ok' => true }, metadata: metadata)
      end

      it 'should return a passing result' do
        expect(middleware.call(next_command, request: request))
          .to be_a_passing_result(Cuprum::Rails::Result)
          .with_value(next_result.value)
          .and_error(next_result.error)
          .and_metadata(metadata)
      end
    end
  end

  describe '#options' do
    include_examples 'should define reader', :options, {}

    context 'when initialized with options' do
      let(:options) { { key: 'value' } }

      it { expect(middleware.options).to be == options }
    end
  end
end
