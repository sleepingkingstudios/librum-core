# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::ApplicationController do
  describe '.repository' do
    it 'should define the class reader' do
      expect(described_class)
        .to define_reader(:repository)
        .with_value(an_instance_of(Cuprum::Rails::Records::Repository))
    end
  end
end
