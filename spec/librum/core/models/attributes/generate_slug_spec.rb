# frozen_string_literal: true

require 'rails_helper'

require 'librum/core/models/attributes/generate_slug'

RSpec.describe Librum::Core::Models::Attributes::GenerateSlug do
  subject(:command) { described_class.new(**constructor_options) }

  let(:constructor_options) { {} }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to respond_to(:new)
        .with(0).arguments
        .and_keywords(:attribute_names)
    end

    describe 'with attribute_names: nil' do
      let(:error_message) { "attribute names can't be blank" }

      it 'should raise an exception' do
        expect { described_class.new(attribute_names: nil) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with attribute_names: an Object' do
      let(:object)        { Object.new.freeze }
      let(:error_message) { "invalid attribute name #{object.inspect}" }

      it 'should raise an exception' do
        expect { described_class.new(attribute_names: object) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with attribute_names: an empty Array' do
      let(:error_message) { "attribute names can't be blank" }

      it 'should raise an exception' do
        expect { described_class.new(attribute_names: []) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with attribute_names: an Array containing nil' do
      let(:error_message) { 'invalid attribute name nil' }

      it 'should raise an exception' do
        expect { described_class.new(attribute_names: [nil]) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with attribute_names: an Array containing an Object' do
      let(:object)        { Object.new.freeze }
      let(:error_message) { "invalid attribute name #{object.inspect}" }

      it 'should raise an exception' do
        expect { described_class.new(attribute_names: [object]) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with attribute_names: an Array containing an empty String' do
      let(:object)        { [''] }
      let(:error_message) { "invalid attribute name #{object.inspect}" }

      it 'should raise an exception' do
        expect { described_class.new(attribute_names: [object]) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with attribute_names: an Array containing an empty Symbol' do
      let(:object)        { [:''] }
      let(:error_message) { "invalid attribute name #{object.inspect}" }

      it 'should raise an exception' do
        expect { described_class.new(attribute_names: [object]) }
          .to raise_error ArgumentError, error_message
      end
    end
  end

  describe '#attribute_names' do
    include_examples 'should define reader', :attribute_names, %w[name]

    context 'when initialized with attribute_names: a String' do
      let(:attribute_names) { 'title' }
      let(:constructor_options) do
        super().merge(attribute_names: attribute_names)
      end

      it { expect(command.attribute_names).to be == %w[title] }
    end

    context 'when initialized with attribute_names: a Symbol' do
      let(:attribute_names) { :title }
      let(:constructor_options) do
        super().merge(attribute_names: attribute_names)
      end

      it { expect(command.attribute_names).to be == %w[title] }
    end

    context 'when initialized with attribute_names: an Array of Strings' do
      let(:attribute_names) { %w[title author] }
      let(:constructor_options) do
        super().merge(attribute_names: attribute_names)
      end

      it { expect(command.attribute_names).to be == %w[title author] }
    end

    context 'when initialized with attribute_names: an Array of Symbols' do
      let(:attribute_names) { %i[title author] }
      let(:constructor_options) do
        super().merge(attribute_names: attribute_names)
      end

      it { expect(command.attribute_names).to be == %w[title author] }
    end
  end

  describe '#call' do
    it 'should define the method' do
      expect(command)
        .to be_callable
        .with(0).arguments
        .and_keywords(:attributes)
    end

    describe 'with nil' do
      let(:error_message) { 'attributes must be a Hash' }

      it 'should raise an exception' do
        expect { command.call(attributes: nil) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an Object' do
      let(:error_message) { 'attributes must be a Hash' }

      it 'should raise an exception' do
        expect { command.call(attributes: Object.new.freeze) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an empty Hash' do
      it 'should pass and return an empty string' do
        expect(command.call(attributes: {}))
          .to be_a_passing_result
          .with_value('')
      end
    end

    describe 'with a Hash that does not contain the attribute' do
      it 'should pass and return an empty string' do
        expect(command.call(attributes: { 'key' => 'value' }))
          .to be_a_passing_result
          .with_value('')
      end
    end

    describe 'with a nil value' do
      let(:attributes) { { 'name' => nil } }

      it 'should pass and return an empty string' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value('')
      end
    end

    describe 'with an Object value' do
      let(:attributes) { { 'name' => Object.new.freeze } }
      let(:expected_error) do
        Cuprum::Error.new(message: %(Value of "name" must be a String))
      end

      it 'should fail and return an error' do
        expect(command.call(attributes: attributes))
          .to be_a_failing_result
          .with_error(expected_error)
      end
    end

    describe 'with an empty String' do
      let(:attributes) { { 'name' => '' } }

      it 'should pass and return an empty string' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value('')
      end
    end

    describe 'with a one-word String' do
      let(:attributes) { { 'name' => 'Flumph' } }

      it 'should pass and return the converted string' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value('flumph')
      end
    end

    describe 'with a multi-word String' do
      let(:attributes) { { 'name' => 'Complete Flumph Manual' } }

      it 'should pass and return the converted string' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value('complete-flumph-manual')
      end
    end

    describe 'with a string with leading and trailing whitespace' do
      let(:attributes) { { 'name' => "\n\tComplete Flumph Manual \n" } }

      it 'should pass and return the converted string' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value('complete-flumph-manual')
      end
    end

    describe 'with a string with interstitial whitespace' do
      let(:attributes) { { 'name' => "Complete\tFlumph\tManual" } }

      it 'should pass and return the converted string' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value('complete-flumph-manual')
      end
    end

    describe 'with a string with numbers' do
      let(:attributes) { { 'name' => 'Complete Flumph Manual 1st Edition' } }

      it 'should pass and return the converted string' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value('complete-flumph-manual-1st-edition')
      end
    end

    describe 'with a string with multiple numbers' do
      let(:attributes) { { 'name' => 'Complete Flumph Manual 11th Edition' } }

      it 'should pass and return the converted string' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value('complete-flumph-manual-11th-edition')
      end
    end

    describe 'with a string with non-letter characters' do
      let(:attributes) { { 'name' => "Flumph Master's Guide" } }

      it 'should pass and return the converted string' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value('flumph-masters-guide')
      end
    end

    describe 'with a string with only non-letter characters' do
      let(:attributes) { { 'name' => '---' } }

      it 'should pass and return an empty string' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value('')
      end
    end

    describe 'with a kebab-case string' do
      let(:attributes) { { 'name' => 'complete-flumph-manual' } }

      it 'should pass and return the converted string' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value('complete-flumph-manual')
      end
    end

    describe 'with an underscored string' do
      let(:attributes) { { 'name' => 'complete_flumph_manual' } }

      it 'should pass and return the converted string' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value('complete-flumph-manual')
      end
    end

    describe 'with a String with a Symbol key' do
      let(:attributes) { { name: 'Flumph' } }

      it 'should pass and return the converted string' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value('flumph')
      end
    end

    context 'when initialized with attribute_names: a String' do
      let(:attribute_names) { 'title' }
      let(:constructor_options) do
        super().merge(attribute_names: attribute_names)
      end

      describe 'with an empty Hash' do
        it 'should pass and return an empty string' do
          expect(command.call(attributes: {}))
            .to be_a_passing_result
            .with_value('')
        end
      end

      describe 'with a Hash that does not contain the attribute' do
        it 'should pass and return an empty string' do
          expect(command.call(attributes: { 'key' => 'value' }))
            .to be_a_passing_result
            .with_value('')
        end
      end

      describe 'with a Hash that contains the attribute' do
        it 'should pass and return the converted string' do
          expect(command.call(attributes: { 'title' => 'Tentacles!' }))
            .to be_a_passing_result
            .with_value('tentacles')
        end
      end
    end

    context 'when initialized with attribute_names: an Array of Strings' do
      let(:attribute_names) { %w[title author] }
      let(:constructor_options) do
        super().merge(attribute_names: attribute_names)
      end

      describe 'with an empty Hash' do
        it 'should pass and return an empty string' do
          expect(command.call(attributes: {}))
            .to be_a_passing_result
            .with_value('')
        end
      end

      describe 'with a Hash that does not contain any of the attributes' do
        it 'should pass and return an empty string' do
          expect(command.call(attributes: { 'key' => 'value' }))
            .to be_a_passing_result
            .with_value('')
        end
      end

      describe 'with a Hash that contains some of the attributes' do
        it 'should pass and return the converted string' do
          expect(command.call(attributes: { 'author' => 'By: A Flumph' }))
            .to be_a_passing_result
            .with_value('by-a-flumph')
        end
      end

      describe 'with a Hash that contains all of the attributes' do
        let(:attributes) do
          {
            'author' => 'By: A Flumph',
            'title'  => 'Tentacles!'
          }
        end

        it 'should pass and return the converted string' do
          expect(command.call(attributes: attributes))
            .to be_a_passing_result
            .with_value('tentacles-by-a-flumph')
        end
      end
    end
  end
end
