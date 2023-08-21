# frozen_string_literal: true

require 'librum/core/actions/view/not_found'

RSpec.describe Librum::Core::Actions::View::NotFound do
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
        .with_value(an_instance_of(Librum::Core::View::Components::NotFound))
        .and_error(nil)
    end
  end
end
