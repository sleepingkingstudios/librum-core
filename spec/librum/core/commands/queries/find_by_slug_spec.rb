# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::Commands::Queries::FindBySlug do
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
        .and_keywords(:slug)
    end

    context 'when the entity does not exist' do
      let(:slug) { 'non-existing-slug' }
      let(:expected_error) do
        Cuprum::Collections::Errors::NotFound.new(
          attribute_name:  'slug',
          attribute_value: slug,
          collection_name: collection.name
        )
      end

      it 'should return a failing result' do
        expect(query.call(slug: slug))
          .to be_a_failing_result
          .with_error(expected_error)
      end
    end

    context 'when one matching entity exists' do
      let(:user) { FactoryBot.create(:user) }

      it 'should return the entity' do
        expect(query.call(slug: user.slug))
          .to be_a_passing_result
          .with_value(user)
      end
    end

    context 'when multiple matching entities exist' do
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
        expect(query.call(slug: 'example-user'))
          .to be_a_failing_result
          .with_error(expected_error)
      end
    end
  end

  describe '#collection' do
    include_examples 'should define reader', :collection, -> { collection }
  end
end
