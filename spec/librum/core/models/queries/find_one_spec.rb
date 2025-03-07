# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::Models::Queries::FindOne do
  subject(:query) { described_class.new(collection: collection) }

  let(:repository) { Cuprum::Rails::Records::Repository.new }
  let(:collection) do
    repository.find_or_create(entity_class: Spec::Support::User)
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:collection)
    end
  end

  describe '#call' do
    it 'should define the method' do
      expect(query)
        .to be_callable
        .with(0).arguments
        .and_keywords(:value)
    end

    describe 'with an id that does not match an entity' do
      let(:value) { SecureRandom.uuid }
      let(:expected_error) do
        Cuprum::Collections::Errors::NotFound.new(
          attribute_name:  'id',
          attribute_value: value,
          collection_name: collection.name,
          primary_key:     true
        )
      end

      it 'should return a failing result' do
        expect(query.call(value: value))
          .to be_a_failing_result
          .with_error(expected_error)
      end
    end

    describe 'with an id that matches an entity' do
      let(:user) { FactoryBot.create(:user) }

      it 'should return the entity' do
        expect(query.call(value: user.id))
          .to be_a_passing_result
          .with_value(user)
      end
    end

    describe 'with a slug that does not match any entities' do
      let(:value) { 'non-existing-slug' }
      let(:expected_error) do
        Cuprum::Collections::Errors::NotFound.new(
          attribute_name:  'slug',
          attribute_value: value,
          collection_name: collection.name
        )
      end

      it 'should return a failing result' do
        expect(query.call(value: value))
          .to be_a_failing_result
          .with_error(expected_error)
      end
    end

    describe 'with a slug that matches one entity' do
      let(:user) { FactoryBot.create(:user) }

      it 'should return the entity' do
        expect(query.call(value: user.slug))
          .to be_a_passing_result
          .with_value(user)
      end
    end

    describe 'with a slug that matches multiple entities' do
      let(:users) do
        Array.new(2) { FactoryBot.build(:user, slug: 'example-user') }
      end
      let(:mock_command) { instance_double(Cuprum::Command, call: users) }
      let(:expected_error) do
        Cuprum::Collections::Errors::NotUnique.new(
          attribute_name:  'slug',
          attribute_value: 'example-user',
          collection_name: collection.name
        )
      end

      before(:example) do
        allow(collection).to receive(:find_matching).and_return(mock_command)
      end

      it 'should return a failing result' do
        expect(query.call(value: 'example-user'))
          .to be_a_failing_result
          .with_error(expected_error)
      end
    end
  end

  describe '#collection' do
    include_examples 'should define reader', :collection, -> { collection }
  end
end
