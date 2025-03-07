# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/repository'
require 'cuprum/rails/rspec/contracts/actions/index_contracts'

require 'support/user'

RSpec.describe Librum::Core::Actions::Index, type: :action do
  include Cuprum::Rails::RSpec::Contracts::Actions::IndexContracts

  subject(:action) { described_class.new }

  let(:repository) { Cuprum::Rails::Records::Repository.new }
  let(:resource) do
    Cuprum::Rails::Resource.new(
      default_order: :name,
      entity_class:  Spec::Support::User
    )
  end
  let(:users) do
    Array
      .new(3) { FactoryBot.build(:user) }
      .sort_by(&:name)
  end

  before(:example) { users.map(&:save!) }

  include_contract 'should be an index action', existing_entities: -> { users }
end
