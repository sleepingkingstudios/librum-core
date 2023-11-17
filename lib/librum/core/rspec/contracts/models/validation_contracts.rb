# frozen_string_literal: true

require 'cuprum/rails/rspec/contract_helpers'
require 'rspec/sleeping_king_studios/contract'

module Librum::Core::RSpec::Contracts::Models
  module ValidationContracts
    # Contract asserting that the attribute format is validated.
    module ShouldValidateTheFormatOfContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |attr_name, **options|
        matching    = options.fetch(:matching, [])
        nonmatching = options.fetch(:nonmatching, %w[xyzzy])
        message     = options.fetch(:message, 'is invalid')

        matching.each do |value|
          value, desc =
            if value.is_a?(Array)
              value
            else
              # :nocov:
              [value, value]
              # :nocov:
            end

          context "when #{attr_name} is #{desc}" do
            let(:attributes) { super().merge(attr_name => value) }

            it 'should not have an error' do
              expect(subject).not_to have_errors.on(attr_name)
            end
          end
        end

        nonmatching.each do |value|
          value, desc =
            if value.is_a?(Array)
              value
            else
              # :nocov:
              [value, value]
              # :nocov:
            end

          context "when #{attr_name} is #{desc}" do
            let(:attributes) { super().merge(attr_name => value) }

            it 'should have an error' do
              expect(subject).to have_errors.on(attr_name).with_message(message)
            end
          end
        end
      end
    end

    # Contract asserting that the attribute is included in the enumerable.
    module ShouldValidateTheInclusionOfContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |attr_name, attributes: nil, **options|
        message = options.fetch(:message, 'is not included in the list')
        values  = options.fetch(:in)

        context "when #{attr_name} is nil" do
          include Cuprum::Rails::RSpec::ContractHelpers

          let(:attributes) do
            option_with_default(
              attributes,
              default: super().merge(attr_name => nil)
            )
          end

          # :nocov:
          if options[:allow_nil]
            it 'should not have an error' do
              expect(subject)
                .not_to have_errors
                .on(attr_name)
                .with_message(message)
            end
          else
            it 'should have an error' do
              expect(subject).to have_errors.on(attr_name).with_message(message)
            end
          end
          # :nocov:
        end

        context "when #{attr_name} is an invalid value" do
          include Cuprum::Rails::RSpec::ContractHelpers

          let(:attributes) do
            option_with_default(
              attributes,
              default: super().merge(attr_name => Object.new)
            )
          end

          it 'should have an error' do
            expect(subject).to have_errors.on(attr_name).with_message(message)
          end
        end

        values.each do |value|
          context "when #{attr_name} is #{value}" do
            include Cuprum::Rails::RSpec::ContractHelpers

            let(:attributes) do
              option_with_default(
                attributes,
                default: super().merge(attr_name => value)
              )
            end

            it 'should not have an error' do
              expect(subject).not_to have_errors.on(attr_name)
            end
          end
        end
      end
    end

    # Contract asserting that the attribute is validated as numeric.
    module ShouldValidateTheNumericalityOfContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |attr_name, **contract_options|
        unless contract_options[:allow_nil]
          context "when #{attr_name} is nil" do
            include Cuprum::Rails::RSpec::ContractHelpers

            let(:attributes) do
              option_with_default(
                contract_options[:attributes],
                default: super().merge(attr_name => nil)
              )
            end
            let(:configured_message) do
              contract_options.fetch(:message, 'is not a number')
            end

            it 'should have an error' do
              expect(subject)
                .to have_errors
                .on(attr_name)
                .with_message(configured_message)
            end
          end
        end

        context "when #{attr_name} is not a number" do
          include Cuprum::Rails::RSpec::ContractHelpers

          let(:attributes) do
            option_with_default(
              contract_options[:attributes],
              default: super().merge(attr_name => 'iv')
            )
          end
          let(:configured_message) do
            contract_options.fetch(:message, 'is not a number')
          end

          it 'should have an error' do
            expect(subject)
              .to have_errors
              .on(attr_name)
              .with_message(configured_message)
          end
        end

        if contract_options[:greater_than]
          gt_value = contract_options[:greater_than]

          context "when #{attr_name} is less than #{gt_value}" do
            include Cuprum::Rails::RSpec::ContractHelpers

            let(:attributes) do
              option_with_default(
                contract_options[:attributes],
                default: super().merge(attr_name => (gt_value - 1))
              )
            end
            let(:configured_message) do
              "must be greater than #{gt_value}"
            end

            it 'should have an error' do
              expect(subject)
                .to have_errors
                .on(attr_name)
                .with_message(configured_message)
            end
          end

          context "when #{attr_name} is equal to #{gt_value}" do
            include Cuprum::Rails::RSpec::ContractHelpers

            let(:attributes) do
              option_with_default(
                contract_options[:attributes],
                default: super().merge(attr_name => gt_value)
              )
            end
            let(:configured_message) do
              "must be greater than #{gt_value}"
            end

            it 'should have an error' do
              expect(subject)
                .to have_errors
                .on(attr_name)
                .with_message(configured_message)
            end
          end
        end

        if contract_options[:greater_than_or_equal_to]
          gte_value = contract_options[:greater_than_or_equal_to]

          context "when #{attr_name} is less than #{gte_value}" do
            include Cuprum::Rails::RSpec::ContractHelpers

            let(:attributes) do
              option_with_default(
                contract_options[:attributes],
                default: super().merge(attr_name => (gte_value - 1))
              )
            end
            let(:configured_message) do
              "must be greater than or equal to #{gte_value}"
            end

            it 'should have an error' do
              expect(subject)
                .to have_errors
                .on(attr_name)
                .with_message(configured_message)
            end
          end

          context "when #{attr_name} is equal to #{gte_value}" do
            include Cuprum::Rails::RSpec::ContractHelpers

            let(:attributes) do
              option_with_default(
                contract_options[:attributes],
                default: super().merge(attr_name => gte_value)
              )
            end

            it { expect(subject).not_to have_errors.on(attr_name) }
          end
        end

        if contract_options[:less_than]
          lt_value = contract_options[:less_than]

          context "when #{attr_name} is greater than #{lt_value}" do
            include Cuprum::Rails::RSpec::ContractHelpers

            let(:attributes) do
              option_with_default(
                contract_options[:attributes],
                default: super().merge(attr_name => (lt_value + 1))
              )
            end
            let(:configured_message) do
              "must be less than #{lt_value}"
            end

            it 'should have an error' do
              expect(subject)
                .to have_errors
                .on(attr_name)
                .with_message(configured_message)
            end
          end

          context "when #{attr_name} is equal to #{lt_value}" do
            include Cuprum::Rails::RSpec::ContractHelpers

            let(:attributes) do
              option_with_default(
                contract_options[:attributes],
                default: super().merge(attr_name => lt_value)
              )
            end
            let(:configured_message) do
              "must be less than #{lt_value}"
            end

            it 'should have an error' do
              expect(subject)
                .to have_errors
                .on(attr_name)
                .with_message(configured_message)
            end
          end
        end

        if contract_options[:less_than_or_equal_to]
          lte_value = contract_options[:less_than_or_equal_to]

          context "when #{attr_name} is greater than #{lte_value}" do
            include Cuprum::Rails::RSpec::ContractHelpers

            let(:attributes) do
              option_with_default(
                contract_options[:attributes],
                default: super().merge(attr_name => (lte_value + 1))
              )
            end
            let(:configured_message) do
              "must be less than or equal to #{lte_value}"
            end

            it 'should have an error' do
              expect(subject)
                .to have_errors
                .on(attr_name)
                .with_message(configured_message)
            end
          end

          context "when #{attr_name} is equal to #{lte_value}" do
            include Cuprum::Rails::RSpec::ContractHelpers

            let(:attributes) do
              option_with_default(
                contract_options[:attributes],
                default: super().merge(attr_name => lte_value)
              )
            end

            it { expect(subject).not_to have_errors.on(attr_name) }
          end
        end

        if contract_options[:only_integer]
          context "when #{attr_name} is not an integer" do
            include Cuprum::Rails::RSpec::ContractHelpers

            let(:attributes) do
              option_with_default(
                contract_options[:attributes],
                default: super().merge(attr_name => 0.0)
              )
            end
            let(:configured_message) do
              config = contract_options[:only_integer]

              if config.is_a?(Hash) && config.key?(:message)
                next config[:message]
              end

              'must be an integer'
            end

            it 'should have an error' do
              expect(subject)
                .to have_errors
                .on(attr_name)
                .with_message(configured_message)
            end
          end
        end
      end
    end

    # Contract asserting that the attribute presence is validated.
    module ShouldValidateThePresenceOfContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |attr_name, attributes: nil, message: nil, type: nil|
        # :nocov:
        def self.normalize_attribute_type(value)
          return nil if value.nil?

          return value.name.underscore if value.is_a?(Class)

          value.to_s
        end
        # :nocov:

        attr_type = normalize_attribute_type(type)
        message ||= "can't be blank"

        context "when #{attr_name} is nil" do
          include Cuprum::Rails::RSpec::ContractHelpers

          let(:attributes) do
            option_with_default(
              attributes,
              default: super().merge(attr_name => nil)
            )
          end

          it 'should have an error' do
            expect(subject).to have_errors.on(attr_name).with_message(message)
          end
        end

        if attr_type == 'string'
          context "when #{attr_name} is empty" do
            include Cuprum::Rails::RSpec::ContractHelpers

            let(:attributes) do
              option_with_default(
                attributes,
                default: super().merge(attr_name => '')
              )
            end

            it 'should have an error' do
              expect(subject).to have_errors.on(attr_name).with_message(message)
            end
          end
        end
      end
    end

    # Contract asserting that the attribute is unique within a given scope.
    module ShouldValidateTheScopedUniquenessOfContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |attr_name, scope:, attributes: {}|
        context "when a #{described_class} exists with the same #{attr_name}" do
          let(:value)   { subject.send(attr_name) }
          let(:message) { 'has already been taken' }

          scoped_contexts =
            scope.reduce([{}]) do |ary, (attribute, values)|
              values
                .map do |value|
                  ary.dup.map { |hsh| hsh.merge(attribute => value) }
                end
                .flatten
            end
          tools = SleepingKingStudios::Tools::Toolbelt.instance

          scoped_contexts.each do |scope_attributes|
            attributes_list =
              scope_attributes
              .map { |attr, value| "#{attr}: #{value.inspect}" }
              .then { |list| tools.array_tools.humanize_list(list) }

            context "with #{attributes_list}" do
              let(:injected_attributes) do
                # :nocov:
                if attributes.is_a?(Proc)
                  instance_exec(&attributes)
                else
                  attributes
                end
                # :nocov:
              end

              before(:example) do
                described_class.create!(
                  injected_attributes
                    .merge(attr_name => value)
                    .merge(scope_attributes)
                )
              end

              # rubocop:disable RSpec/ExampleLength
              # rubocop:disable RSpec/MultipleExpectations
              it 'should check the scope' do
                scopes_match =
                  scope_attributes
                  .reduce(true) do |memo, (scope_attribute, scope_value)|
                    memo && subject.send(scope_attribute) == scope_value
                  end

                if scopes_match
                  expect(subject)
                    .to have_errors
                    .on(attr_name)
                    .with_message(message)
                else
                  expect(subject).not_to have_errors.on(attr_name)
                end
              end
              # rubocop:enable RSpec/ExampleLength
              # rubocop:enable RSpec/MultipleExpectations
            end
          end
        end
      end
    end

    # Contract asserting that the attribute is unique.
    module ShouldValidateTheUniquenessOfContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |attr_name, attributes: {}, **options|
        context "when a #{described_class} exists with the same #{attr_name}" do
          let(:value)        { subject.send(attr_name) }
          let(:message)      { 'has already been taken' }
          let(:factory_name) do
            return options[:factory_name] if options.key?(:factory_name)

            return super() if defined?(super())

            described_class.name.split('::').last.underscore.intern
          end
          let(:injected_attributes) do
            if attributes.is_a?(Proc)
              instance_exec(&attributes)
            else
              attributes
            end
          end

          before(:example) do
            attributes =
              FactoryBot
              .attributes_for(factory_name)
              .merge(injected_attributes)
              .merge(attr_name.intern => value)

            described_class.create!(attributes)
          end

          it 'should have an error' do
            expect(subject).to have_errors.on(attr_name).with_message(message)
          end
        end
      end
    end
  end
end
