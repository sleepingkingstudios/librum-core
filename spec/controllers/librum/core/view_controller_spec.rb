# frozen_string_literal: true

require 'rails_helper'

require 'librum/core/rspec/contracts/controller_contracts'

RSpec.describe Librum::Core::ViewController do
  include Librum::Core::RSpec::Contracts::ControllerContracts

  describe '.default_format' do
    it { expect(described_class.default_format).to be :html }
  end

  describe '.repository' do
    it 'should define the class reader' do
      expect(described_class)
        .to define_reader(:repository)
        .with_value(an_instance_of(Cuprum::Rails::Repository))
    end
  end

  describe '.responders' do
    include_contract 'should respond to format',
      :html,
      using: Librum::Core::Responders::Html::ViewResponder

    include_contract 'should not respond to format', :json
  end
end
