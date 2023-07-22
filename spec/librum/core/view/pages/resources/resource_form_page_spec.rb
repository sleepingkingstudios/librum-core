# frozen_string_literal: true

require 'rails_helper'

require 'stannum'

RSpec.describe Librum::Core::View::Pages::Resources::ResourceFormPage,
  type: :component \
do
  subject(:page) { described_class.new(result, resource: resource) }

  shared_context 'with data: a Hash' do
    let(:rocket) { Struct.new(:name).new('Imp IV') }
    let(:value)  { { resource.singular_resource_name => rocket } }
    let(:result) { Cuprum::Result.new(value: value) }
  end

  shared_context 'with data: an Object' do
    let(:rocket) { Struct.new(:name).new('Imp IV') }
    let(:result) { Cuprum::Result.new(value: rocket) }
  end

  shared_context 'with errors' do
    let(:errors) do
      Stannum::Errors.new.add('spec.error', message: 'Something went wrong')
    end
    let(:error) do
      Cuprum::Collections::Errors::InvalidParameters.new(
        command: Cuprum::Command.new,
        errors:  errors
      )
    end
    let(:result) { Cuprum::Result.new(error: error) }
  end

  let(:result)   { Cuprum::Result.new }
  let(:resource) { Cuprum::Rails::Resource.new(resource_name: 'rockets') }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(1).argument
        .and_keywords(:resource)
        .and_any_keywords
    end
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
        Librum::Core::View::Pages::Resources::ResourceFormPage \
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
        Librum::Core::View::Pages::Resources::ResourceFormPage \
      do |klass|
        default = default_data

        klass.define_method(:default_data) { default }
      end
      # rubocop:enable RSpec/DescribedClass

      it { expect(page.data).to be == default_data }
    end
  end

  describe '#form_errors' do
    include_examples 'should define reader', :form_errors, nil

    wrap_context 'with errors' do
      it { expect(page.form_errors).to be == errors }
    end
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
        Librum::Core::View::Pages::Resources::ResourceFormPage \
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
        Librum::Core::View::Pages::Resources::ResourceFormPage \
      do |klass|
        default = default_data

        klass.define_method(:default_data) { default }
      end
      # rubocop:enable RSpec/DescribedClass

      it { expect(page.resource_data).to be == default_data }
    end
  end

  describe '#resource_name' do
    include_examples 'should define reader',
      :resource_name,
      -> { resource.resource_name }
  end

  describe '#singular_resource_name' do
    include_examples 'should define reader',
      :singular_resource_name,
      -> { resource.singular_resource_name }
  end
end
