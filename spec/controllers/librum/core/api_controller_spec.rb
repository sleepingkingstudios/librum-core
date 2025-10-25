# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/rspec/deferred/controller_examples'

RSpec.describe Librum::Core::ApiController, type: :controller do
  include Cuprum::Rails::RSpec::Deferred::ControllerExamples
  include Librum::Core::RSpec::Contracts::ControllerContracts

  describe '.default_format' do
    it { expect(described_class.default_format).to be :json }
  end

  describe '.responders' do
    include_deferred 'should respond to format',
      :json,
      using: Librum::Core::Responders::JsonResponder

    include_deferred 'should not respond to format', :html
  end

  describe '.serializers' do
    include_contract 'should use the default serializers'
  end
end
