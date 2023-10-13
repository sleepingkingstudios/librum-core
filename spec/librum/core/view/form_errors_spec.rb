# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::FormErrors, type: :item_component do
  include Librum::Core::RSpec::Contracts::ComponentContracts

  subject(:component) { described_class.new(**options) }

  let(:described_class) { Spec::ExampleComponent }
  let(:name)            { 'color' }
  let(:options)         { { name: name } }

  example_class 'Spec::ExampleComponent', ViewComponent::Base do |klass|
    klass.include Librum::Core::View::Options
    klass.include Librum::Core::View::FormErrors # rubocop:disable RSpec/DescribedClass

    klass.option :name
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:error_key, :errors)
        .and_any_keywords
    end
  end

  include_contract 'should define options',
    expected_options: { name: 'color' }

  include_contract 'should define option', :error_key, default: -> { name }

  include_contract 'should define option', :errors

  describe '#matching_errors' do
    let(:errors)  { nil }
    let(:options) { super().merge(errors: errors) }

    it { expect(component).to respond_to(:matching_errors).with(0).arguments }

    it { expect(component.matching_errors).to be == [] }

    describe 'when initialized with errors: an Object' do
      let(:errors) { Object.new.freeze }

      it { expect(component.matching_errors).to be == [] }
    end

    describe 'when initialized with errors: an empty Array' do
      let(:errors) { [] }

      it { expect(component.matching_errors).to be == [] }
    end

    describe 'when initialized with errors: an Array of Strings' do
      let(:errors) { ['is not red', 'is not green', 'is not blue'] }

      it { expect(component.matching_errors).to be == errors }
    end

    describe 'when initialized with an empty errors object' do
      let(:errors) { Stannum::Errors.new }

      it { expect(component.matching_errors).to be == [] }
    end

    describe 'when initialized with an errors object with matching errors' do
      let(:errors) do
        err =
          Stannum::Errors
          .new
          .add('spec.errors.blurry', message: 'is blurry')

        err[name]
          .add('spec.errors.not_red',   message: 'is not red')
          .add('spec.errors.not_green', message: 'is not green')
          .add('spec.errors.not_blue',  message: 'is not blue')

        err['format']
          .add('spec.errors.invalid', message: 'is invalid')

        err
      end
      let(:expected_errors) { ['is not red', 'is not green', 'is not blue'] }

      it { expect(component.matching_errors).to be == expected_errors }
    end

    describe 'when initialized with name: a bracket-scoped name' do
      let(:name) { 'image[color]' }

      it { expect(component.matching_errors).to be == [] }

      describe 'when initialized with an empty errors object' do
        let(:errors) { Stannum::Errors.new }

        it { expect(component.matching_errors).to be == [] }
      end

      describe 'when initialized with an errors object with matching errors' do
        let(:errors) do
          err =
            Stannum::Errors
            .new
            .add('spec.errors.blurry', message: 'is blurry')

          err[name]
            .add('spec.errors.not_red',   message: 'is not red')
            .add('spec.errors.not_green', message: 'is not green')

          err['image']['color']
            .add('spec.errors.not_green', message: 'is not green')
            .add('spec.errors.not_blue',  message: 'is not blue')

          err['format']
            .add('spec.errors.invalid', message: 'is invalid')

          err
        end
        let(:expected_errors) { ['is not red', 'is not green', 'is not blue'] }

        it { expect(component.matching_errors).to be == expected_errors }
      end
    end

    describe 'when initialized with name: a period-scoped name' do
      let(:name) { 'image.color' }

      it { expect(component.matching_errors).to be == [] }

      describe 'when initialized with an empty errors object' do
        let(:errors) { Stannum::Errors.new }

        it { expect(component.matching_errors).to be == [] }
      end

      describe 'when initialized with an errors object with matching errors' do
        let(:errors) do
          err =
            Stannum::Errors
            .new
            .add('spec.errors.blurry', message: 'is blurry')

          err[name]
            .add('spec.errors.not_red',   message: 'is not red')
            .add('spec.errors.not_green', message: 'is not green')

          err['image']['color']
            .add('spec.errors.not_green', message: 'is not green')
            .add('spec.errors.not_blue',  message: 'is not blue')

          err['format']
            .add('spec.errors.invalid', message: 'is invalid')

          err
        end
        let(:expected_errors) { ['is not red', 'is not green', 'is not blue'] }

        it { expect(component.matching_errors).to be == expected_errors }
      end
    end
  end
end
