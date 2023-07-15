# frozen_string_literal: true

require 'rails_helper'

require 'librum/core/rspec/factories/shared_factories'

RSpec.describe Librum::Core::RSpec::Factories::SharedFactories do
  let(:described_class) { Spec::CustomFactory }

  example_constant 'Spec::CustomFactory' do
    Module.new do
      extend Librum::Core::RSpec::Factories::SharedFactories
    end
  end

  describe '.define_factories' do
    let(:dsl) do
      instance_double(FactoryBot::Syntax::Default::DSL, factory: nil)
    end
    let(:registry) do
      instance_double(FactoryBot::Registry, any?: false)
    end

    before(:example) do
      allow(FactoryBot).to receive(:define) do |&block|
        dsl.instance_exec(&block)
      end

      allow(FactoryBot).to receive(:factories).and_return(registry)
    end

    it 'should define the class method' do
      expect(described_class).to respond_to(:define_factories).with(0).arguments
    end

    it 'should not define any factories' do
      described_class.define_factories

      expect(dsl).not_to have_received(:factory)
    end

    context 'when there is a configured factory' do
      let(:part_options) { {} }
      let(:part_block)   { -> {} }

      before(:example) do
        described_class.factory(:part, **part_options, &part_block)
      end

      it 'should define the configured factory' do
        described_class.define_factories

        expect(dsl).to have_received(:factory).with(:part, &part_block)
      end

      context 'when the factory is configured with options' do
        let(:part_options) { super().merge(aliases: :rocket_part) }

        it 'should define the configured factory' do
          described_class.define_factories

          expect(dsl)
            .to have_received(:factory)
            .with(:part, **part_options, &part_block)
        end
      end

      context 'when the factory is already defined' do
        before(:example) do
          allow(registry)
            .to receive(:any?)
            .and_yield(Struct.new(:name).new(:part))
        end

        it 'should not redefine the factory' do
          described_class.define_factories

          expect(dsl).not_to have_received(:factory)
        end
      end
    end

    context 'when there are many configured factories' do
      let(:assembly_block) { -> {} }
      let(:part_block)     { -> {} }
      let(:rocket_block)   { -> {} }

      before(:example) do
        described_class.factory(:assembly, &assembly_block)

        described_class.factory(:part,     &part_block)

        described_class.factory(:rocket, aliases: :spaceship, &rocket_block)
      end

      it 'should define the configured factories', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
        described_class.define_factories

        expect(dsl).to have_received(:factory).exactly(3).times
        expect(dsl).to have_received(:factory).with(:assembly, &assembly_block)
        expect(dsl).to have_received(:factory).with(:part,     &part_block)
        expect(dsl)
          .to have_received(:factory)
          .with(:rocket, aliases: :spaceship, &rocket_block)
      end
    end
  end

  describe '.factory' do
    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:factory)
        .with(1).argument
        .and_any_keywords
        .and_a_block
    end

    it { expect(described_class.factory :part).to be :part }
  end
end
