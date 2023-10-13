# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Options do
  include Librum::Core::RSpec::Contracts::ComponentContracts

  subject(:component) { described_class.new(**options) }

  let(:described_class) { Spec::ExampleComponent }
  let(:options)         { {} }

  example_class 'Spec::ExampleComponent', ViewComponent::Base do |klass|
    klass.include Librum::Core::View::Options # rubocop:disable RSpec/DescribedClass
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_any_keywords
    end
  end

  describe '.option' do
    let(:option_name)   { :color }
    let(:option_params) { {} }

    before(:example) { described_class.option(option_name, **option_params) }

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:option)
        .with(1).argument
        .and_keywords(:boolean, :default)
    end

    describe 'with default options' do
      include_contract 'should define option', :color
    end

    describe 'with boolean: true' do
      let(:option_name)   { :ssto }
      let(:option_params) { super().merge(boolean: true) }

      include_contract 'should define option', :ssto, boolean: true

      describe '#:option_name?' do
        include_examples 'should define predicate', :ssto?, false

        context 'when initialized with option: false' do
          let(:options) { super().merge(ssto: false) }

          it { expect(component.ssto?).to be false }
        end

        context 'when initialized with option: true' do
          let(:options) { super().merge(ssto: true) }

          it { expect(component.ssto?).to be true }
        end
      end

      describe '#options' do
        it { expect(component.options[option_name]).to be nil }

        context 'when initialized with option: false' do
          let(:options) { super().merge(ssto: false) }

          it { expect(component.options[option_name]).to be false }
        end

        context 'when initialized with option: true' do
          let(:options) { super().merge(ssto: true) }

          it { expect(component.options[option_name]).to be true }
        end
      end

      describe 'with default: a Proc' do
        let(:default)       { -> { stages == 1 } }
        let(:option_params) { super().merge(default: default) }

        before(:example) { Spec::ExampleComponent.attr_accessor :stages }

        include_contract 'should define option',
          :ssto,
          boolean: true,
          default: -> { stages == 1 }
      end

      describe 'with default: a value' do
        let(:option_params) { super().merge(default: true) }

        include_contract 'should define option',
          :ssto,
          boolean: true,
          default: true
      end
    end

    describe 'with default: a Proc' do
      let(:default)       { -> { speed == 'fast' ? 'red' : 'grey' } }
      let(:option_params) { super().merge(default: default) }

      before(:example) { Spec::ExampleComponent.attr_accessor :speed }

      include_contract 'should define option',
        :color,
        default: -> { speed == 'fast' ? 'red' : 'grey' }

      describe '#:option_name' do
        context 'when the object state matches the predicate' do
          before(:example) { component.speed = 'fast' }

          it { expect(component.color).to be == 'red' }
        end
      end
    end

    describe 'with default: a value' do
      let(:option_params) { super().merge(default: 'red') }

      include_contract 'should define option', :color, default: 'red'
    end
  end

  include_contract 'should define options'

  context 'with a subclass with defined options' do
    let(:described_class) { Spec::Rocket }

    example_class 'Spec::Rocket', 'Spec::ExampleComponent' do |klass|
      klass.option :color
      klass.option :stages, default: 0
      klass.option :ssto?,  boolean: true, default: -> { stages == 1 }
    end

    include_contract 'should define option', :color,  value: 'red'

    include_contract 'should define option', :stages, default: 0

    include_contract 'should define option',
      :ssto?,
      boolean: true,
      default: -> { stages.size == 1 }

    describe '#ssto?' do
      context 'with stages: 1' do
        let(:options) { super().merge(stages: 1) }

        it { expect(component.ssto?).to be true }
      end
    end
  end
end
