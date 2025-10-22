# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/rspec/deferred/resource_examples'

RSpec.describe Librum::Core::Resource do
  include Cuprum::Rails::RSpec::Deferred::ResourceExamples

  it { expect(described_class).to be < Cuprum::Rails::Resource }

  it { expect(described_class).to be < Librum::Components::Resource }
end
