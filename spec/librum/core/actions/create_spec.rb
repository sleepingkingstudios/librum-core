# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/repository'
require 'cuprum/rails/rspec/actions/create_contracts'

require 'support/user'

RSpec.describe Librum::Core::Actions::Create, type: :action do
  include Cuprum::Rails::RSpec::Actions::CreateContracts

  subject(:action) { described_class.new }

  let(:repository) { Cuprum::Rails::Repository.new }
  let(:resource) do
    Cuprum::Rails::Resource.new(
      entity_class:         Spec::Support::User,
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
    {
      'name'     => 'Example User',
      'password' => '12345'
    }
  end
  let(:expected_attributes) do
    { 'slug' => 'example-user' }
  end

  include_contract 'create action contract',
    invalid_attributes:             -> { invalid_attributes },
    valid_attributes:               -> { valid_attributes },
    expected_attributes_on_failure: ->(hsh) { hsh.merge({ 'slug' => '' }) },
    expected_attributes_on_success: ->(hsh) { hsh.merge(expected_attributes) } \
  do
    describe 'with slug: an empty String' do
      let(:valid_attributes) { super().merge({ 'slug' => '' }) }

      include_contract 'should create the entity',
        valid_attributes:    -> { valid_attributes },
        expected_attributes: ->(hsh) { hsh.merge(expected_attributes) }
    end

    describe 'with slug: a valid slug' do
      let(:valid_attributes) { super().merge({ 'slug' => 'example-slug' }) }

      include_contract 'should create the entity',
        valid_attributes: -> { valid_attributes }
    end
  end
end
