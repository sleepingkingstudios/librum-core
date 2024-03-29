# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Pages::Resources::ResourcePage,
  type: :component \
do
  subject(:page) { described_class.new(result, resource: resource) }

  shared_context 'with data: a Hash' do
    let(:rocket) { Struct.new(:name).new('Imp IV') }
    let(:value)  { { resource.singular_name => rocket } }
    let(:result) { Cuprum::Result.new(value: value) }
  end

  shared_context 'with data: an Object' do
    let(:rocket) { Struct.new(:name).new('Imp IV') }
    let(:result) { Cuprum::Result.new(value: rocket) }
  end

  let(:result)   { Cuprum::Result.new }
  let(:resource) { Cuprum::Rails::Resource.new(name: 'rockets') }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(1).argument
        .and_keywords(:resource)
        .and_any_keywords
    end
  end

  describe '#actions' do
    include_examples 'should define reader', :actions, -> { resource.actions }
  end

  describe '#data' do
    include_examples 'should define reader', :resource_data, nil

    wrap_context 'with data: a Hash' do
      it { expect(page.data).to be == value }
    end

    wrap_context 'with data: an Object' do
      it { expect(page.data).to be == rocket }
    end

    context 'with a subclass with default_data: a Hash' do
      let(:described_class) { Spec::ExamplePage }
      let(:default_data)    { Struct.new(:name).new('Imp IV') }

      # rubocop:disable RSpec/DescribedClass
      example_class 'Spec::ExamplePage',
        Librum::Core::View::Pages::Resources::ResourcePage \
      do |klass|
        default = default_data

        klass.define_method(:default_data) do
          { 'rocket' => default }
        end
      end
      # rubocop:enable RSpec/DescribedClass

      it { expect(page.data).to be == { 'rocket' => default_data } }
    end

    context 'with a subclass with default_data: an Object' do
      let(:described_class) { Spec::ExamplePage }
      let(:default_data)    { Struct.new(:name).new('Imp IV') }

      # rubocop:disable RSpec/DescribedClass
      example_class 'Spec::ExamplePage',
        Librum::Core::View::Pages::Resources::ResourcePage \
      do |klass|
        default = default_data

        klass.define_method(:default_data) { default }
      end
      # rubocop:enable RSpec/DescribedClass

      it { expect(page.data).to be == default_data }
    end
  end

  describe '#resource' do
    include_examples 'should define reader', :resource, -> { resource }
  end

  describe '#resource_data' do
    include_examples 'should define reader', :resource_data, nil

    # rubocop:disable RSpec/RepeatedExampleGroupBody
    wrap_context 'with data: a Hash' do
      it { expect(page.resource_data).to be == rocket }
    end

    wrap_context 'with data: an Object' do
      it { expect(page.resource_data).to be == rocket }
    end
    # rubocop:enable RSpec/RepeatedExampleGroupBody

    context 'with a subclass with default_data: a Hash' do
      let(:described_class) { Spec::ExamplePage }
      let(:default_data)    { Struct.new(:name).new('Imp IV') }

      # rubocop:disable RSpec/DescribedClass
      example_class 'Spec::ExamplePage',
        Librum::Core::View::Pages::Resources::ResourcePage \
      do |klass|
        default = default_data

        klass.define_method(:default_data) do
          { 'rocket' => default }
        end
      end
      # rubocop:enable RSpec/DescribedClass

      it { expect(page.resource_data).to be == default_data }
    end

    context 'with a subclass with default_data: an Object' do
      let(:described_class) { Spec::ExamplePage }
      let(:default_data)    { Struct.new(:name).new('Imp IV') }

      # rubocop:disable RSpec/DescribedClass
      example_class 'Spec::ExamplePage',
        Librum::Core::View::Pages::Resources::ResourcePage \
      do |klass|
        default = default_data

        klass.define_method(:default_data) { default }
      end
      # rubocop:enable RSpec/DescribedClass

      it { expect(page.resource_data).to be == default_data }
    end
  end

  describe '#routes' do
    let(:params) { {} }
    let(:request) do
      instance_double(ActionDispatch::Request, path_parameters: params)
    end
    let(:controller) do
      instance_double(ActionController::Base, request: request)
    end

    before(:example) do
      allow(page).to receive(:controller).and_return(controller) # rubocop:disable RSpec/SubjectStub
    end

    include_examples 'should define reader', :routes

    it 'should return the resource routes', :aggregate_failures do
      expect(page.routes).to be_a resource.routes.class

      expect(page.routes.base_path).to be == resource.routes.base_path
      expect(page.routes.wildcards).to be == resource.routes.wildcards
    end

    context 'when the request has path parameters' do
      let(:params) { { 'id' => 'custom-slug' } }

      it { expect(page.routes.wildcards).to be == params }
    end
  end
end
