# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::Actions::View::RenderPage do
  subject(:action) { described_class.new(resource: resource) }

  let(:resource) { Cuprum::Rails::Resource.new(resource_name: 'rockets') }

  describe '#call' do
    let(:request) { Object.new.freeze }

    it 'should define the method' do
      expect(action).to be_callable.with(0).arguments.and_keywords(:request)
    end

    it 'should return a passing result' do
      expect(action.call(request: request))
        .to be_a_passing_result
        .with_value(nil)
        .and_error(nil)
    end
  end
end
