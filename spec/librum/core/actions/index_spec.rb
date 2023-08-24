# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/repository'
require 'cuprum/rails/rspec/actions/index_contracts'

require 'support/user'

RSpec.describe Librum::Core::Actions::Index, type: :action do
  include Cuprum::Rails::RSpec::Actions::IndexContracts

  subject(:action) { described_class.new }

  let(:repository) { Cuprum::Rails::Repository.new }
  let(:resource) do
    Cuprum::Rails::Resource.new(
      default_order:  :name,
      resource_class: Spec::Support::User
    )
  end
  let(:users) do
    Array
      .new(3) { FactoryBot.build(:user) }
      .sort_by(&:name)
  end

  before(:example) { users.map(&:save!) }

  include_contract 'index action contract', existing_entities: -> { users }
end
