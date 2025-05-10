# frozen_string_literal: true

require 'cuprum/rails/resource'
require 'rspec/sleeping_king_studios/deferred/provider'

require 'support/examples/commands'

module Spec::Support::Examples::Commands
  module UsersExamples
    include RSpec::SleepingKingStudios::Deferred::Provider

    # Sample data for User objects.
    USERS_FIXTURES = [
      {
        'id'       => '0196b858-6ba3-77f7-8194-e57ebeb5e615',
        'name'     => 'Kevin Flynn',
        'slug'     => 'kevin-flynn',
        'role'     => 'user',
        'password' => 'theperfectsystem'
      }.freeze,
      {
        'id'       => '0196b857-8f4b-7904-b4db-5c6b74213a99',
        'name'     => 'Alan Bradley',
        'slug'     => 'alan-bradley',
        'role'     => 'user',
        'password' => 'tronlives'
      }.freeze,
      {
        'id'       => '0196b883-000d-72b8-a6c3-2b86c784a634',
        'name'     => 'Walter Gibbs',
        'slug'     => 'walter-gibbs',
        'role'     => 'user',
        'password' => 'wontthatbegrand'
      }.freeze,
      {
        'id'       => '0196b859-039b-775f-be6b-e5686574ef8c',
        'name'     => 'Ed Dillinger',
        'slug'     => 'ed-dillinger',
        'role'     => 'admin',
        'password' => 'mastercontrol'
      }.freeze
    ].freeze

    deferred_context 'with parameters for a User command' do
      let(:repository) { Cuprum::Collections::Basic::Repository.new }
      let(:resource) do
        Cuprum::Rails::Resource.new(name: 'users', **resource_options)
      end
      let(:resource_options) do
        {
          default_order:        'id',
          permitted_attributes:,
          primary_key_name:     'id'
        }
      end
      let(:permitted_attributes) do
        %w[name password role slug]
      end
      let(:collection_options) { { primary_key_type: String } }
      let(:default_contract) do
        Stannum::Contracts::HashContract.new(allow_extra_keys: true) do
          key 'name', Stannum::Constraints::Presence.new
          key 'role', Stannum::Constraints::Presence.new
        end
      end
      let(:fixtures_data) { USERS_FIXTURES }

      ##########################################################################
      ###                         Resource Parameters                        ###
      ##########################################################################

      let(:extra_attributes) do
        {
          'derezzed' => false
        }
      end
      let(:invalid_attributes) do
        {
          'name' => 'CLU',
          'role' => nil
        }
      end
      let(:valid_attributes) do
        {
          'name' => 'CLU',
          'role' => 'program'
        }
      end
    end
  end
end
