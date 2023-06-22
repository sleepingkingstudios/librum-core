# frozen_string_literal: true

require 'rails_helper'

require 'librum/core/actions/view/middleware/page_navigation'

RSpec.describe Librum::Core::Actions::View::Middleware::PageNavigation do
  subject(:middleware) { described_class.new(navigation: navigation) }

  let(:navigation) { { icon: 'radiation', label: 'Home' } }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:navigation)
        .and_any_keywords
    end
  end

  describe '#call' do
    let(:next_result)   { Cuprum::Result.new(value: { 'ok' => true }) }
    let(:next_command)  { instance_double(Cuprum::Command, call: next_result) }
    let(:request)       { Cuprum::Rails::Request.new }
    let(:page_metadata) { { navigation: navigation } }

    it 'should call the next command' do
      middleware.call(next_command, request: request)

      expect(next_command).to have_received(:call).with(request: request)
    end

    it 'should return a passing result' do
      expect(middleware.call(next_command, request: request))
        .to be_a_passing_result(Cuprum::Rails::Result)
        .with_value(next_result.value)
        .and_error(next_result.error)
        .and_metadata({ page: page_metadata })
    end

    describe 'with a result with page metadata' do
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
      let(:expected_metadata) do
        metadata.merge(
          page: metadata[:page].merge(page_metadata)
        )
      end

      it 'should return a passing result' do
        expect(middleware.call(next_command, request: request))
          .to be_a_passing_result(Cuprum::Rails::Result)
          .with_value(next_result.value)
          .and_error(next_result.error)
          .and_metadata(expected_metadata)
      end
    end
  end

  describe '#navigation' do
    include_examples 'should define reader', :navigation, -> { navigation }
  end
end
