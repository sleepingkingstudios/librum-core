# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::FormSelect::Option,
  type: :component \
do
  subject(:component) { described_class.new(**constructor_options) }

  let(:label) { 'KSC' }
  let(:value) { 0 }
  let(:constructor_options) do
    {
      label: label,
      value: value
    }
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:label, :value, :disabled, :selected)
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(component) }
    let(:snapshot) do
      <<~HTML
        <option value="0">KSC</option>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with disabled: true' do
      let(:constructor_options) { super().merge(disabled: true) }
      let(:snapshot) do
        <<~HTML
          <option value="0" disabled="disabled">KSC</option>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with selected: true' do
      let(:constructor_options) { super().merge(selected: true) }
      let(:snapshot) do
        <<~HTML
          <option value="0" selected="selected">KSC</option>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#disabled?' do
    include_examples 'should define predicate', :disabled?, false

    context 'when initialized with disabled: false' do
      let(:constructor_options) { super().merge(disabled: false) }

      it { expect(component.disabled?).to be false }
    end

    context 'when initialized with disabled: true' do
      let(:constructor_options) { super().merge(disabled: true) }

      it { expect(component.disabled?).to be true }
    end
  end

  describe '#label' do
    include_examples 'should define reader', :label, -> { label }
  end

  describe '#options' do
    include_examples 'should define reader', :options, -> { {} }

    context 'when initialized with disabled: false' do
      let(:constructor_options) { super().merge(disabled: false) }

      it { expect(component.options).to be == { disabled: false } }
    end

    context 'when initialized with disabled: true' do
      let(:constructor_options) { super().merge(disabled: true) }

      it { expect(component.options).to be == { disabled: true } }
    end

    context 'when initialized with selected: false' do
      let(:constructor_options) { super().merge(selected: false) }

      it { expect(component.options).to be == { selected: false } }
    end

    context 'when initialized with selected: true' do
      let(:constructor_options) { super().merge(selected: true) }

      it { expect(component.options).to be == { selected: true } }
    end

    context 'when initialized with custom options' do
      let(:constructor_options) { super().merge(custom: 'value') }

      it { expect(component.options).to be == { custom: 'value' } }
    end
  end

  describe '#selected?' do
    include_examples 'should define predicate', :selected?, false

    context 'when initialized with selected: false' do
      let(:constructor_options) { super().merge(selected: false) }

      it { expect(component.selected?).to be false }
    end

    context 'when initialized with selected: true' do
      let(:constructor_options) { super().merge(selected: true) }

      it { expect(component.selected?).to be true }
    end
  end

  describe '#value' do
    include_examples 'should define reader', :value, -> { value }
  end
end
