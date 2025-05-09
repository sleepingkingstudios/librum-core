# frozen_string_literal: true

require 'rspec/sleeping_king_studios/contract'

module Librum::Core::RSpec::Contracts::Models
  # :nocov:

  module AssociationsContracts
    # Contract asserting the model class has a :belongs_to association.
    module ShouldBelongToContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |association_name, **options, &block|
        include Librum::Core::RSpec::Contracts::Models::AttributesContracts

        association_name = association_name.intern
        factory_name     = options.fetch(:factory_name, association_name)
        foreign_key_name = options.fetch(:foreign_key) do
          :"#{association_name}_id"
        end
        model_name       =
          described_class.name.split('::').last.underscore.tr('_', ' ')
        display_name     = association_name.to_s.tr('_', ' ')

        include_contract 'should define attribute',
          foreign_key_name,
          value: lambda {
            attributes.fetch(foreign_key_name.intern) do
              attributes.fetch(foreign_key_name.to_s) { SecureRandom.uuid }
            end
          }

        describe "##{association_name}" do
          include_examples 'should define property', association_name

          context "when the #{model_name} has a #{display_name}" do
            let(:association) do
              case options[:association]
              when Proc
                instance_exec(&options[:association])
              when nil
                FactoryBot.build(factory_name)
              else
                options[:association]
              end
            end
            let(:attributes) do
              super().merge({ association_name => association })
            end
            let(:association_value) { subject.send(association_name) }

            before(:example) { association.save! }

            it { expect(association_value).to be == association }
          end
        end

        instance_exec(&block) if block
      end
    end

    # Contract asserting the model class has a :has_one association.
    module ShouldHaveOneContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |association_name, **options, &block|
        include Librum::Core::RSpec::Contracts::Models::AttributesContracts

        association_name = association_name.intern
        factory_name     = options.fetch(:factory_name, association_name)
        model_name       =
          described_class.name.split('::').last.underscore.tr('_', ' ')
        display_name     = association_name.to_s.tr('_', ' ')
        inverse_name     =
          options.fetch(:inverse_name, model_name.tr(' ', '_')).intern

        describe "##{association_name}" do
          include_examples 'should define property', association_name

          context "when the #{model_name} has a #{display_name}" do
            let(:association) do
              case options[:association]
              when Proc
                instance_exec(&options[:association])
              when nil
                FactoryBot.build(factory_name, inverse_name => subject)
              else
                options[:association]
              end
            end
            let(:attributes) do
              super().merge({ association_name => association })
            end
            let(:association_value) { subject.send(association_name) }

            before(:example) do
              subject.save!

              association.save!
            end

            it { expect(association_value).to be == association }
          end
        end

        instance_exec(&block) if block
      end
    end

    # Contract asserting the model class has a :has_many association.
    module ShouldHaveManyContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |association_name, **options, &block|
        association_name = association_name.intern
        singular_name    = association_name.to_s.singularize.intern
        factory_name     = options.fetch(:factory_name, singular_name)
        model_name       =
          described_class.name.split('::').last.underscore.tr('_', ' ')
        display_name     = association_name.to_s.tr('_', ' ')
        inverse_name     =
          options.fetch(:inverse_name, model_name.tr(' ', '_')).intern

        describe "##{association_name}" do
          include_examples 'should define reader', association_name, []

          context "when the #{model_name} has many #{display_name}" do
            let(:associations) do
              case options[:association]
              when Proc
                instance_exec(&options[:association])
              when nil
                Array.new(3) do
                  FactoryBot.build(factory_name, inverse_name => subject)
                end
              else
                options[:association]
              end
            end
            let(:association_value) { subject.send(association_name) }

            before(:example) do
              if options[:before_example].is_a?(Proc)
                instance_exec(&options[:before_example])
              end

              subject.save!

              associations.map(&:save!)
            end

            it { expect(association_value).to match_array(associations) }
          end

          instance_exec(&block) if block
        end
      end
    end
  end
  # :nocov:
end
