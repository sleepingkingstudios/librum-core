# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/repository'
require 'cuprum/rails/rspec/contracts/actions/show_contracts'

require 'support/models/user'

RSpec.describe Librum::Core::Actions::Show, type: :action do
  include Cuprum::Rails::RSpec::Contracts::Actions::ShowContracts

  subject(:action) { described_class.new }

  let(:repository) { Cuprum::Rails::Records::Repository.new }
  let(:resource) do
    Cuprum::Rails::Resource.new(entity_class: User)
  end
  let(:user) { FactoryBot.build(:user) }

  before(:example) { user.save }

  include_contract 'should be a show action',
    existing_entity:   -> { user },
    primary_key_value: -> { SecureRandom.uuid } \
  do
    describe 'with id: a slug' do
      let(:params) { { 'id' => user.slug } }

      include_contract 'should find the entity',
        existing_entity: -> { user },
        params:          -> { params }
    end
  end
end
