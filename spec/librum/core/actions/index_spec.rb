# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/repository'
require 'cuprum/rails/rspec/actions/index_contracts'

require 'librum/core/actions/index'

require 'support/user'

RSpec.describe Librum::Core::Actions::Index, type: :action do
  include Cuprum::Rails::RSpec::Actions::IndexContracts

  subject(:action) do
    described_class.new(repository: repository, resource: resource)
  end

  let(:repository) { Cuprum::Rails::Repository.new }
  let(:resource) do
    Cuprum::Rails::Resource.new(
      collection:     repository.find_or_create(
        record_class: Spec::Support::User
      ),
      default_order:  :name,
      resource_class: Spec::Support::User
    )
  end
  let(:users) { Array.new(3) { FactoryBot.build(:user) } }

  before(:example) { users.map(&:save!) }

  include_contract 'index action contract', existing_entities: -> { users }
end
