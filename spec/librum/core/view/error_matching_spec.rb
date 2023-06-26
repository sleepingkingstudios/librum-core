# frozen_string_literal: true

require 'rails_helper'

require 'librum/core/view/error_matching'

RSpec.describe Librum::Core::View::ErrorMatching do
  subject(:component) { described_class.new(name: name, errors: errors) }

  let(:described_class) { Spec::ComponentWithErrors }
  let(:name)            { 'color' }
  let(:errors)          { nil }

  example_class 'Spec::ComponentWithErrors',
    Struct.new(:name, :errors, keyword_init: true) do |klass|
      klass.include Librum::Core::View::ErrorMatching # rubocop:disable RSpec/DescribedClass
    end

  describe '#matching_errors' do
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
