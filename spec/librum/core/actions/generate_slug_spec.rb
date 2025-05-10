# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::Actions::GenerateSlug do
  subject(:action) { described_class.new(action_name) }

  let(:action_name)     { :create }
  let(:described_class) { Spec::Action }

  example_class 'Spec::Action', Cuprum::Command do |klass|
    klass.prepend(Librum::Core::Actions::GenerateSlug) # rubocop:disable RSpec/DescribedClass

    klass.define_method(:initialize) do |action|
      @action = action
    end

    klass.attr_reader :action

    klass.define_method(:create_entity) do |attributes:|
      attributes
    end

    klass.define_method(:update_entity) do |attributes:|
      attributes
    end

    klass.define_method(:process) do |attributes:|
      if action == :create
        create_entity(attributes: attributes)
      else
        update_entity(attributes: attributes)
      end
    end
  end

  describe '#call' do
    let(:command_class) { Librum::Core::Commands::Attributes::GenerateSlug }
    let(:command) do
      instance_double(
        Librum::Core::Commands::Attributes::GenerateSlug,
        call: result
      )
    end
    let(:result) do
      Cuprum::Result.new(value: 'example-slug')
    end

    before(:example) do
      allow(command_class).to receive(:new).and_return(command)
    end

    context 'when the action is create' do
      let(:action_name) { :create }

      describe 'with an empty attributes Hash' do
        let(:expected_attributes) { { 'slug' => 'example-slug' } }

        it 'should set an empty slug' do
          expect(action.call(attributes: {}))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end

      describe 'with an attributes Hash with slug: an empty String' do
        let(:expected_attributes) { { 'slug' => 'example-slug' } }

        it 'should set an empty slug' do
          expect(action.call(attributes: { 'slug' => '' }))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end

      describe 'with an attributes Hash with slug: an String' do
        let(:expected_attributes) { { 'slug' => 'custom-slug' } }

        it 'should set an empty slug' do
          expect(action.call(attributes: { 'slug' => 'custom-slug' }))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end
    end

    context 'when the action is update' do
      let(:action_name) { :update }

      describe 'with an empty attributes Hash' do
        let(:expected_attributes) { {} }

        it 'should set an empty slug' do
          expect(action.call(attributes: {}))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end

      describe 'with an attributes Hash with slug: an empty String' do
        let(:expected_attributes) { { 'slug' => 'example-slug' } }

        it 'should set an empty slug' do
          expect(action.call(attributes: { 'slug' => '' }))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end

      describe 'with an attributes Hash with slug: an String' do
        let(:expected_attributes) { { 'slug' => 'custom-slug' } }

        it 'should set an empty slug' do
          expect(action.call(attributes: { 'slug' => 'custom-slug' }))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end
    end
  end
end
