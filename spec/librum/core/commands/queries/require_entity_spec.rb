# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/collections/basic/collection'

require 'support/examples/commands/users_examples'

RSpec.describe Librum::Core::Commands::Queries::RequireEntity do
  subject(:command) { described_class.new(collection:, **options) }

  let(:collection) do
    Cuprum::Collections::Basic::Collection.new(
      name:             'users',
      primary_key_type: String
    )
  end
  let(:options) { { require_primary_key: true } }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:collection, :require_primary_key)
    end
  end

  describe '#call' do
    let(:fixtures_data) do
      Spec::Support::Examples::Commands::UsersExamples::USERS_FIXTURES
    end
    let(:parameters) { {} }

    define_method :call_command do
      command.call(**parameters)
    end

    it 'should define the method' do
      expect(command)
        .to be_callable
        .with(0).arguments
        .and_keywords(:entity, :primary_key)
        .and_any_keywords
    end

    context 'when initialized with require_primary_key: false' do
      let(:options) { super().merge(require_primary_key: false) }

      describe 'with entity: value' do
        let(:entity)     { fixtures_data.first }
        let(:parameters) { { entity: } }

        it 'should return a passing result with the entity' do
          expect(call_command)
            .to be_a_passing_result
            .with_value(entity)
        end
      end

      context 'when there are no values matching the resource scope' do
        let(:expected_error) do
          Cuprum::Collections::Errors::NotFound.new(
            collection_name: collection.name,
            query:           collection.query
          )
        end

        it 'should return a failing result' do
          expect(call_command)
            .to be_a_failing_result
            .with_error(expected_error)
        end
      end

      context 'when there is one value matching the resource scope' do
        let(:entity) { fixtures_data.first }

        before(:example) do
          result = collection.insert_one.call(entity:)

          raise result.error.message if result.error
        end

        it 'should return a passing result with the entity' do
          expect(call_command)
            .to be_a_passing_result
            .with_value(entity)
        end
      end

      context 'when there are many values matching the resource scope' do
        let(:entities) { fixtures_data }
        let(:expected_error) do
          Cuprum::Collections::Errors::NotUnique.new(
            collection_name: collection.name,
            query:           collection.query
          )
        end

        before(:example) do
          entities.each do |entity|
            result = collection.insert_one.call(entity:)

            raise result.error.message if result.error
          end
        end

        it 'should return a failing result' do
          expect(call_command)
            .to be_a_failing_result
            .with_error(expected_error)
        end
      end
    end

    context 'when initialized with require_primary_key: true' do
      let(:options) { super().merge(require_primary_key: true) }

      describe 'with entity: nil and primary_key: nil' do
        let(:parameters) { {} }
        let(:expected_error) do
          collection
            .find_one
            .call(primary_key: nil)
            .error
        end

        it 'should return a failing result' do
          expect(call_command)
            .to be_a_failing_result
            .with_error(expected_error)
        end
      end

      describe 'with entity: value' do
        let(:entity)     { fixtures_data.first }
        let(:parameters) { { entity: } }

        it 'should return a passing result with the entity' do
          expect(call_command)
            .to be_a_passing_result
            .with_value(entity)
        end
      end

      describe 'with primary_key: invalid id' do
        let(:primary_key) { '88dc320a-4a94-4b14-a9a7-5ca5bc78be21' }
        let(:parameters)  { { primary_key: } }
        let(:expected_error) do
          collection
            .find_one
            .call(primary_key:)
            .error
        end

        it 'should return a failing result' do
          expect(call_command)
            .to be_a_failing_result
            .with_error(expected_error)
        end
      end

      describe 'with primary_key: invalid slug' do
        let(:primary_key) { 'custom-slug' }
        let(:parameters)  { { primary_key: } }
        let(:expected_error) do
          Cuprum::Collections::Errors::NotFound.new(
            attribute_name:  'slug',
            attribute_value: primary_key,
            collection_name: collection.name
          )
        end

        it 'should return a failing result' do
          expect(call_command)
            .to be_a_failing_result
            .with_error(expected_error)
        end
      end

      describe 'with primary_key: valid id' do
        let(:entity) do
          entity = fixtures_data.first
          result = collection.insert_one.call(entity:)

          raise result.error.message if result.error

          result.value
        end
        let(:primary_key) { entity['id'] }
        let(:parameters)  { { primary_key: } }

        it 'should return a passing result with the entity' do
          expect(call_command)
            .to be_a_passing_result
            .with_value(entity)
        end
      end

      describe 'with primary_key: valid slug' do
        let(:entity) do
          entity = fixtures_data.first
          result = collection.insert_one.call(entity:)

          raise result.error.message if result.error

          result.value
        end
        let(:primary_key) { entity['slug'] }
        let(:parameters)  { { primary_key: } }

        it 'should return a passing result with the entity' do
          expect(call_command)
            .to be_a_passing_result
            .with_value(entity)
        end
      end
    end
  end

  describe '#collection' do
    include_examples 'should define reader', :collection, -> { collection }
  end

  describe '#require_primary_key?' do
    include_examples 'should define predicate', :require_primary_key?

    context 'when initialized with require_primary_key: false' do
      let(:options) { super().merge(require_primary_key: false) }

      it { expect(command.require_primary_key?).to be false }
    end

    context 'when initialized with require_primary_key: true' do
      let(:options) { super().merge(require_primary_key: true) }

      it { expect(command.require_primary_key?).to be true }
    end
  end
end
