# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/collections/rspec/fixtures'
require 'cuprum/rails/rspec/deferred/commands/resources/edit_examples'

require 'support/examples/commands/users_examples'

RSpec.describe Librum::Core::Commands::Resources::Edit do
  include Cuprum::Rails::RSpec::Deferred::Commands::Resources::EditExamples
  include Spec::Support::Examples::Commands::UsersExamples

  subject(:command) { described_class.new(repository:, resource:) }

  let(:expected_slug) { original_attributes['slug'] }
  let(:expected_attributes) do
    original_attributes
      .merge(tools.hash_tools.convert_keys_to_strings(matched_attributes))
      .merge(
        'id'   => be_a_uuid,
        'slug' => expected_slug
      )
  end

  define_method :tools do
    SleepingKingStudios::Tools::Toolbelt.instance
  end

  include_deferred 'with parameters for a User command'

  include_deferred 'should implement the Edit command' do
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
        let(:original_attributes) do
          matched_entity
        end
        let(:matched_attributes) do
          configured_valid_attributes
        end
        let(:entity)      { nil }
        let(:primary_key) { valid_primary_key_value }

        include_deferred 'should edit the entity'
      end

      describe 'with primary_key: a valid id' do
        let(:entity)      { nil }
        let(:primary_key) { fixtures_data.first['id'] }
        let(:matched_entity) do
          collection
            .find_one
            .call(primary_key:)
            .value
        end
        let!(:original_attributes) do
          matched_entity
        end

        describe 'with slug: nil' do
          let(:matched_attributes) do
            configured_valid_attributes.merge('slug' => nil)
          end
          let(:expected_slug) do
            Librum::Core::Commands::Attributes::GenerateSlug
              .new
              .call(attributes: matched_attributes)
              .value
          end

          include_deferred 'should edit the entity'
        end

        describe 'with slug: an empty String' do
          let(:matched_attributes) do
            configured_valid_attributes.merge('slug' => '')
          end
          let(:expected_slug) do
            Librum::Core::Commands::Attributes::GenerateSlug
              .new
              .call(attributes: matched_attributes)
              .value
          end

          include_deferred 'should edit the entity'
        end

        describe 'with slug: value' do
          let(:slug) { 'custom-slug' }
          let(:original_attributes) do
            matched_entity
          end
          let(:matched_attributes) do
            configured_valid_attributes.merge('slug' => slug)
          end
          let(:expected_slug) { slug }

          include_deferred 'should edit the entity'
        end

        context 'when the entity has a custom slug' do
          let(:fixtures_data) do
            first, *rest = super()

            [first.merge('slug' => 'original-slug'), *rest]
          end
          let(:matched_attributes) do
            configured_valid_attributes
          end
          let(:expected_slug) { original_attributes['slug'] }

          include_deferred 'should edit the entity'

          describe 'with slug: nil' do
            let(:matched_attributes) do
              configured_valid_attributes.merge('slug' => nil)
            end
            let(:expected_slug) do
              Librum::Core::Commands::Attributes::GenerateSlug
                .new
                .call(attributes: matched_attributes)
                .value
            end

            include_deferred 'should edit the entity'
          end

          describe 'with slug: an empty String' do
            let(:matched_attributes) do
              configured_valid_attributes.merge('slug' => '')
            end
            let(:expected_slug) do
              Librum::Core::Commands::Attributes::GenerateSlug
                .new
                .call(attributes: matched_attributes)
                .value
            end

            include_deferred 'should edit the entity'
          end

          describe 'with slug: value' do
            let(:slug) { 'custom-slug' }
            let(:original_attributes) do
              matched_entity
            end
            let(:matched_attributes) do
              configured_valid_attributes.merge('slug' => slug)
            end
            let(:expected_slug) { slug }

            include_deferred 'should edit the entity'
          end
        end
      end
    end
  end
end
