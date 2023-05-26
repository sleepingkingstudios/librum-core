# frozen_string_literal: true

require 'rspec/sleeping_king_studios/contract'

require 'librum/core/rspec/contracts/models'

module Librum::Core::RSpec::Contracts::Models
  module DataPropertiesContracts
    # Contract asserting that the model class defines data proprties.
    module ShouldDefineDataPropertiesContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |base_class: nil|
        describe '.data_property' do
          it 'should define the class method' do
            expect(described_class)
              .to respond_to(:data_property)
              .with(1).argument
              .and_keywords(:predicate)
          end

          context 'with a subclass' do
            let(:described_class) { Spec::ExampleModel }

            example_class 'Spec::ExampleModel', base_class || described_class

            describe 'with a property name' do
              let(:property_name) { :prop_name }

              before(:example) { described_class.data_property(property_name) }

              include_contract 'should define data property', :prop_name
            end

            describe 'with a property name and predicate: true' do
              let(:property_name) { :prop_name }

              before(:example) do
                described_class.data_property(property_name, predicate: true)
              end

              include_contract 'should define data property',
                :prop_name,
                predicate: true
            end
          end
        end
      end
    end

    # Contract asserting that the model class defines the data property.
    module ShouldDefineDataProperty
      extend RSpec::SleepingKingStudios::Contract

      contract do |property_name, predicate: false|
        describe "##{property_name}" do
          it 'should define the reader' do
            expect(subject)
              .to define_reader(property_name)
              .with_value(attributes[:data][property_name.to_s])
          end
        end

        describe "##{property_name}=" do
          let(:writer_name) { :"#{property_name}=" }

          it { expect(subject).to define_writer(property_name) }

          it 'should set the property' do
            expect { subject.send(writer_name, 'new value') }
              .to change(subject, property_name)
              .to be == 'new value'
          end

          it 'should update the data' do
            expect { subject.send(writer_name, 'new value') }
              .to change { subject.data[property_name.to_s] }
              .to be == 'new value'
          end

          context 'when the data includes the value' do
            let(:attributes) do
              data = super()[:data].merge({ property_name.to_s => 'old value' })

              super().merge(data: data)
            end

            it 'should set the property' do
              expect { subject.send(writer_name, 'new value') }
                .to change(subject, property_name)
                .to be == 'new value'
            end

            it 'should update the data' do
              expect { subject.send(writer_name, 'new value') }
                .to change { subject.data[property_name.to_s] }
                .to be == 'new value'
            end
          end
        end

        describe "##{property_name}?" do
          let(:predicate_name) { :"#{property_name}?" }

          if predicate
            it 'should define the predicate' do
              expect(subject).to define_predicate(predicate_name)
            end

            context 'when the value is nil' do
              let(:attributes) do
                data =
                  super()[:data].merge({ property_name.to_s => nil })

                super().merge(data: data)
              end

              it { expect(subject.send(predicate_name)).to be false }
            end

            context 'when the value is false' do
              let(:attributes) do
                data =
                  super()[:data].merge({ property_name.to_s => false })

                super().merge(data: data)
              end

              it { expect(subject.send(predicate_name)).to be false }
            end

            context 'when the value is true' do
              let(:attributes) do
                data =
                  super()[:data].merge({ property_name.to_s => true })

                super().merge(data: data)
              end

              it { expect(subject.send(predicate_name)).to be true }
            end

            context 'when the value is an empty String' do
              let(:attributes) do
                data =
                  super()[:data].merge({ property_name.to_s => '' })

                super().merge(data: data)
              end

              it { expect(subject.send(predicate_name)).to be false }
            end

            context 'when the value is a non-empty String' do
              let(:attributes) do
                data =
                  super()[:data].merge({ property_name.to_s => 'value' })

                super().merge(data: data)
              end

              it { expect(subject.send(predicate_name)).to be true }
            end
          else
            it { expect(subject).not_to define_predicate(predicate_name) }
          end
        end
      end
    end
  end
end
