# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::FormSelect::OptionGroup,
  type: :component \
do
  subject(:component) { described_class.new(**constructor_options) }

  shared_context 'with items' do
    let(:items) do
      [
        {
          label: 'KSC',
          value: '0'
        },
        {
          separator: true
        },
        {
          label: 'Baikerbanur',
          value: '1'
        }
      ]
    end
  end

  let(:label) { 'Kerbin' }
  let(:items) { [] }
  let(:constructor_options) do
    {
      label: label,
      items: items
    }
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:disabled, :items, :label)
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(component) }
    let(:snapshot) do
      <<~HTML
        <optgroup label="Kerbin">
        </optgroup>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    wrap_context 'with items' do
      let(:snapshot) do
        <<~HTML
          <optgroup label="Kerbin">
            <option value="0">KSC</option>

            <option disabled="disabled"> </option>

            <option value="1">Baikerbanur</option>
          </optgroup>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with disabled: true' do
        let(:constructor_options) { super().merge(disabled: true) }
        let(:snapshot) do
          <<~HTML
            <optgroup label="Kerbin" disabled="disabled">
              <option value="0">KSC</option>

              <option disabled="disabled"> </option>

              <option value="1">Baikerbanur</option>
            </optgroup>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with disabled: true' do
      let(:constructor_options) { super().merge(disabled: true) }
      let(:snapshot) do
        <<~HTML
          <optgroup label="Kerbin" disabled="disabled">
          </optgroup>
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

  describe '#items' do
    include_examples 'should define reader', :items, -> { items }

    wrap_context 'with items' do
      it { expect(component.items).to be == items }
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

    context 'when initialized with custom options' do
      let(:constructor_options) { super().merge(custom: 'value') }

      it { expect(component.options).to be == { custom: 'value' } }
    end
  end
end
