# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/repository'
require 'cuprum/rails/rspec/contracts/actions/update_contracts'

require 'support/models/user'

RSpec.describe Librum::Core::Actions::Update do
  include Cuprum::Rails::RSpec::Contracts::Actions::UpdateContracts

  subject(:action) { described_class.new }

  let(:repository) { Cuprum::Rails::Records::Repository.new }
  let(:resource) do
    Cuprum::Rails::Resource.new(
      entity_class:         User,
      permitted_attributes: %i[
        name
        slug
        password
      ]
    )
  end
  let(:invalid_attributes) do
    { 'name' => '' }
  end
  let(:valid_attributes) do
    { 'name' => 'Example User' }
  end
  let(:user) { FactoryBot.create(:user) }

  before(:example) { user.save }

  include_contract 'should be an update action',
    existing_entity:    -> { user },
    invalid_attributes: -> { invalid_attributes },
    valid_attributes:   -> { valid_attributes },
    primary_key_value:  -> { SecureRandom.uuid } \
  do
    describe 'with id: a slug' do
      let(:params) do
        { 'id' => user.slug, 'user' => valid_attributes }
      end

      include_contract 'should update the entity',
        existing_entity:  -> { user },
        valid_attributes: -> { valid_attributes },
        params:           -> { params }
    end

    describe 'with slug: an empty String' do
      let(:valid_attributes)    { super().merge({ 'slug' => '' }) }
      let(:expected_attributes) { { 'slug' => 'example-user' } }

      include_contract 'should update the entity',
        existing_entity:     -> { user },
        valid_attributes:    -> { valid_attributes },
        expected_attributes: ->(hsh) { hsh.merge(expected_attributes) }
    end

    describe 'with slug: a valid slug' do
      let(:valid_attributes) { super().merge({ 'slug' => 'example-slug' }) }

      include_contract 'should update the entity',
        existing_entity:  -> { user },
        valid_attributes: -> { valid_attributes }
    end
  end
end
