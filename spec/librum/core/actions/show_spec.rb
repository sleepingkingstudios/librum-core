# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/repository'
require 'cuprum/rails/rspec/actions/show_contracts'

require 'support/user'

RSpec.describe Librum::Core::Actions::Show, type: :action do
  include Cuprum::Rails::RSpec::Actions::ShowContracts

  subject(:action) { described_class.new }

  let(:repository) { Cuprum::Rails::Repository.new }
  let(:resource) do
    Cuprum::Rails::Resource.new(entity_class: Spec::Support::User)
  end
  let(:user) { FactoryBot.build(:user) }

  before(:example) { user.save }

  include_contract 'show action contract',
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
