# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/collections/rspec/fixtures'
require 'cuprum/rails/rspec/deferred/commands/resources/destroy_examples'

require 'support/examples/commands/users_examples'

RSpec.describe Librum::Core::Commands::Resources::Destroy do
  include Cuprum::Rails::RSpec::Deferred::Commands::Resources::DestroyExamples
  include Spec::Support::Examples::Commands::UsersExamples

  subject(:command) { described_class.new(repository:, resource:) }

  include_deferred 'with parameters for a User command'

  include_deferred 'should implement the Destroy command' do
    wrap_deferred 'when the collection has many items' do
      describe 'with primary_key: an invalid slug' do
        let(:invalid_primary_key_value) do
          'invalid-user'
        end
        let(:entity)      { nil }
        let(:primary_key) { invalid_primary_key_value }
        let(:expected_error) do
          Cuprum::Collections::Errors::NotFound.new(
            attribute_name:  'slug',
            attribute_value: invalid_primary_key_value,
            collection_name: resource.name,
            primary_key:     false
          )
        end

        it 'should return a failing result' do
          expect(call_command)
            .to be_a_failing_result
            .with_error(expected_error)
        end
      end

      describe 'with primary_key: a valid slug' do
        let(:valid_primary_key_value) do
          collection_data.first['slug']
        end
        let(:matched_entity) do
          collection
            .find_matching
            .call(where: { slug: valid_primary_key_value })
            .value
            .first
        end
        let(:entity)      { nil }
        let(:primary_key) { valid_primary_key_value }

        include_deferred 'should destroy the entity'
      end
    end
  end
end
