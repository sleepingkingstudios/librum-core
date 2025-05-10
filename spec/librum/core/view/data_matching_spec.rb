# frozen_string_literal: true

require 'rails_helper'

require 'support/models/rocket'

RSpec.describe Librum::Core::View::DataMatching do
  subject(:component) { described_class.new(name: name, data: data) }

  let(:described_class) { Spec::ComponentWithData }
  let(:name)            { 'color' }
  let(:data)            { nil }

  example_class 'Spec::ComponentWithData',
    Struct.new(:name, :data, keyword_init: true) do |klass|
      klass.include Librum::Core::View::DataMatching # rubocop:disable RSpec/DescribedClass
    end

  describe '#matching_data' do
    it { expect(component).to respond_to(:matching_data).with(0).arguments }

    it { expect(component.matching_data).to be nil }

    context 'with data: a non-matching Hash' do
      let(:data) { { 'name' => 'Imp IV' } }

      it { expect(component.matching_data).to be nil }
    end

    context 'with data: a matching Hash' do
      let(:data) { { 'name' => 'Imp IV', 'color' => 'red' } }

      it { expect(component.matching_data).to be == 'red' }
    end

    context 'with data: an non-matching Object' do
      let(:data) { Rocket.new(name: 'Imp IV') }

      it { expect(component.matching_data).to be nil }
    end

    context 'with data: an Object that does not respond to the method' do
      let(:data) { Spec::ExampleObject.new('name' => 'Imp IV') }

      example_class 'Spec::ExampleObject' do |klass|
        klass.define_method(:initialize) do |**attributes|
          @attributes = attributes
        end

        klass.define_method(:[]) { |key| @attributes[key.to_s] } # rubocop:disable RSpec/InstanceVariable
      end

      context 'when initialized with name: a non-matching name' do
        let(:data) { Spec::ExampleObject.new('name' => 'Imp IV') }

        it { expect(component.matching_data).to be nil }
      end

      context 'when initialized with name: a matching name' do
        let(:data) { Spec::ExampleObject.new('color' => 'red') }

        it { expect(component.matching_data).to be == 'red' }
      end
    end

    context 'with data: an Object that does not respond to #[]' do
      let(:data) { Object.new }

      it { expect(component.matching_data).to be nil }
    end

    context 'with data: a matching Object' do
      let(:data) { Rocket.new(name: 'Imp IV', color: 'red') }

      it { expect(component.matching_data).to be == 'red' }
    end

    context 'with data: an Object with matching method' do
      let(:name) { 'rgb' }
      let(:data) { Spec::ExampleObject.new('red') }

      example_class 'Spec::ExampleObject', Struct.new(:color) do |klass|
        # :nocov:
        klass.define_method(:rgb) do
          case color
          when 'red'
            '#F00'
          when 'green'
            '#0F0'
          when 'blue'
            '#00F'
          else
            '#F36'
          end
        end
        # :nocov:
      end

      it { expect(component.matching_data).to be == '#F00' }
    end

    context 'when initialized with name: a bracket-scoped name' do
      let(:name) { 'rocket[color]' }

      it { expect(component.matching_data).to be nil }

      context 'with non-matching data' do
        let(:data) { { 'launch_site' => 'KSC' } }

        it { expect(component.matching_data).to be nil }
      end

      context 'with partially-matching data' do
        let(:data) { { 'rocket' => Rocket.new(name: 'Imp IV') } }

        it { expect(component.matching_data).to be nil }
      end

      context 'with matching data' do
        let(:data) do
          {
            'rocket' => Rocket.new(name: 'Imp IV', color: 'red')
          }
        end

        it { expect(component.matching_data).to be == 'red' }
      end
    end

    context 'when initialized with name: a period-scoped name' do
      let(:name) { 'rocket.color' }

      it { expect(component.matching_data).to be nil }

      context 'with non-matching data' do
        let(:data) { { 'launch_site' => 'KSC' } }

        it { expect(component.matching_data).to be nil }
      end

      context 'with partially-matching data' do
        let(:data) { { 'rocket' => Rocket.new(name: 'Imp IV') } }

        it { expect(component.matching_data).to be nil }
      end

      context 'with matching data' do
        let(:data) do
          {
            'rocket' => Rocket.new(name: 'Imp IV', color: 'red')
          }
        end

        it { expect(component.matching_data).to be == 'red' }
      end
    end

    context 'when initialized with name: a Hash method name' do
      let(:name) { 'cycle' }
      let(:data) { { 'cycle' => 'bi' } }

      it { expect(component.matching_data).to be == 'bi' }
    end
  end
end
