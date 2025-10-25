# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/rspec/deferred/controller_examples'

RSpec.describe Librum::Core::ViewController do
  include Cuprum::Rails::RSpec::Deferred::ControllerExamples

  describe '.default_format' do
    it { expect(described_class.default_format).to be :html }
  end

  describe '.responders' do
    include_deferred 'should respond to format',
      :html,
      using: Librum::Core::Responders::Html::ViewResponder

    include_deferred 'should not respond to format', :json
  end
end
