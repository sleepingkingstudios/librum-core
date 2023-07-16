# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::ApiController, type: :controller do
  include Librum::Core::RSpec::Contracts::ControllerContracts

  describe '.default_format' do
    it { expect(described_class.default_format).to be :json }
  end

  describe '.repository' do
    subject(:repository) { described_class.repository }

    it { expect(repository).to be_a Cuprum::Rails::Repository }
  end

  describe '.responders' do
    include_contract 'should respond to format',
      :json,
      using: Librum::Core::Responders::JsonResponder

    include_contract 'should not respond to format', :html
  end

  describe '.serializers' do
    include_contract 'should use the default serializers'
  end
end
