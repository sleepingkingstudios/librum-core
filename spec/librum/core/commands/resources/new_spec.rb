# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/collections/rspec/fixtures'
require 'cuprum/rails/rspec/deferred/commands/resources/new_examples'

require 'support/examples/commands/users_examples'

RSpec.describe Librum::Core::Commands::Resources::New do
  include Cuprum::Rails::RSpec::Deferred::Commands::Resources::NewExamples
  include Spec::Support::Examples::Commands::UsersExamples

  subject(:command) { described_class.new(repository:, resource:) }

  let(:expected_slug) do
    next matched_attributes['slug'] if matched_attributes['slug'].present?

    Librum::Core::Commands::Attributes::GenerateSlug
      .new
      .call(attributes: matched_attributes)
      .value
  end
  let(:expected_attributes) do
    empty_attributes
      .merge(tools.hash_tools.convert_keys_to_strings(matched_attributes))
      .merge(
        'id'   => be_a_uuid,
        'slug' => expected_slug
      )
  end

  include_deferred 'with parameters for a User command'

  include_deferred 'should implement the New command' do
    describe 'with id: nil' do
      let(:matched_attributes) do
        configured_valid_attributes.merge('id' => nil)
      end
      let(:permitted_attributes) do
        super() << 'id'
      end

      include_deferred 'should build the entity'
    end

    describe 'with id: an empty String' do
      let(:matched_attributes) do
        configured_valid_attributes.merge('id' => '')
      end
      let(:permitted_attributes) do
        super() << 'id'
      end

      include_deferred 'should build the entity'
    end

    describe 'with id: value' do
      let(:id) { '00000000-0000-0000-0000-000000000000' }
      let(:matched_attributes) do
        configured_valid_attributes.merge('id' => id)
      end
      let(:expected_attributes) do
        super().merge('id' => id)
      end
      let(:permitted_attributes) do
        super() << 'id'
      end

      include_deferred 'should build the entity'
    end

    describe 'with slug: nil' do
      let(:matched_attributes) do
        configured_valid_attributes.merge('slug' => nil)
      end

      include_deferred 'should build the entity'
    end

    describe 'with slug: an empty String' do
      let(:matched_attributes) do
        configured_valid_attributes.merge('slug' => '')
      end

      include_deferred 'should build the entity'
    end

    describe 'with slug: value' do
      let(:slug) { 'custom-slug' }
      let(:matched_attributes) do
        configured_valid_attributes.merge('slug' => slug)
      end
      let(:expected_attributes) do
        super().merge('slug' => slug)
      end

      include_deferred 'should build the entity'
    end
  end
end
