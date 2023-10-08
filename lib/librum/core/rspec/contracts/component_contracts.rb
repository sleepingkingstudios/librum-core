# frozen_string_literal: true

require 'rspec/sleeping_king_studios/contract'

module Librum::Core::RSpec::Contracts
  module ComponentContracts
    # Contract asserting the component defines a standard :class_name option.
    module ShouldDefineClassNameOptionContract
      extend RSpec::SleepingKingStudios::Contract

      contract do
        describe '#class_name' do
          include_examples 'should define reader', :class_name, []

          context 'when initialized with class_name: an Array' do
            let(:class_name) { %w[is-left is-unselectable] }
            let(:options)    { super().merge(class_name: class_name) }

            it { expect(subject.class_name).to be == class_name }
          end

          context 'when initialized with class_name: a String' do
            let(:class_name) { 'is-left' }
            let(:options)    { super().merge(class_name: class_name) }

            it { expect(subject.class_name).to be == Array(class_name) }
          end
        end

        describe '#options' do
          context 'when initialized with class_name: an Array' do
            let(:class_name) { %w[is-left is-unselectable] }
            let(:options)    { super().merge(class_name: class_name) }

            it { expect(subject.options[:class_name]).to be == class_name }
          end

          context 'when initialized with class_name: a String' do
            let(:class_name) { 'is-left' }
            let(:options)    { super().merge(class_name: class_name) }

            it { expect(subject.options[:class_name]).to be == class_name }
          end
        end
      end
    end

    # Contract asserting the component defines the specified option.
    module ShouldDefineOptionContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |option_name, **config|
        describe "##{option_name}" do
          let(:option_key) do
            option_name.to_s.sub(/\?\z/, '').intern
          end
          let(:predicate_name) do
            option_name.to_s.end_with?('?') ? option_name : :"#{option_name}?"
          end
          let(:default_value) do
            next config[:boolean] ? false : nil if config[:default].nil?

            next config[:default] unless config[:default].is_a?(Proc)

            subject.instance_exec(&config[:default])
          end

          if config[:boolean]
            include_examples 'should define predicate',
              :"#{option_name}?",
              -> { default_value }

            context 'when initialized with option: false' do
              let(:options) { super().merge(option_key => false) }

              it { expect(subject.send(predicate_name)).to be == false }
            end

            context 'when initialized with option: true' do
              let(:options) { super().merge(option_key => true) }

              it { expect(subject.send(predicate_name)).to be == true }
            end
          else
            include_examples 'should define reader',
              option_name,
              -> { default_value }

            context 'when initialized with option: value' do
              let(:option_value) { defined?(super()) ? super() : 'value' }
              let(:options)      { super().merge(option_key => option_value) }

              it { expect(subject.send(option_name)).to be == option_value }
            end
          end
        end

        describe '#options' do
          let(:option_key) do
            option_name.to_s.sub(/\?\z/, '').intern
          end

          it { expect(subject.options[option_key]).to be nil }

          if config[:boolean]
            context 'when initialized with option: false' do
              let(:options) { super().merge(option_key => false) }

              it { expect(subject.options[option_key]).to be false }
            end

            context 'when initialized with option: true' do
              let(:options) { super().merge(option_key => true) }

              it { expect(subject.options[option_key]).to be true }
            end
          else
            context 'when initialized with option: value' do
              let(:option_value) { defined?(super()) ? super() : 'value' }
              let(:options)      { super().merge(option_key => option_value) }

              it { expect(subject.options[option_key]).to be == option_value }
            end
          end
        end
      end
    end

    # Contract asserting the component defines arbitrary options.
    module ShouldDefineOptionsContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |**config|
        describe '#options' do
          let(:options) do
            defined?(super()) ? super() : {}
          end
          let(:expected_options) do
            defined?(super()) ? super() : config.fetch(:expected_options, {})
          end

          include_examples 'should define reader',
            :options,
            -> { expected_options }

          context 'when initialized with custom options' do
            let(:options)          { super().merge(custom: 'value') }
            let(:expected_options) { super().merge(custom: 'value') }

            it { expect(subject.options).to be == expected_options }
          end
        end
      end
    end
  end
end
