# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::Button, type: :component do
  subject(:button) { described_class.new(**options) }

  let(:options) { {} }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:color, :label, :type)
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(button) }
    let(:snapshot) do
      <<~HTML
        <button type="button" class="button"></button>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with class_names: an Array of Strings' do
      let(:class_names) { %w[is-classification has-property] }
      let(:options)     { super().merge(class_names: class_names) }
      let(:snapshot) do
        <<~HTML
          <button type="button" class="button is-classification has-property"></button>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with class_names: a String' do
      let(:class_names) { 'is-classification has-property' }
      let(:options)     { super().merge(class_names: class_names) }
      let(:snapshot) do
        <<~HTML
          <button type="button" class="button is-classification has-property"></button>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with color: value' do
      let(:color)   { 'danger' }
      let(:options) { super().merge(color: color) }
      let(:snapshot) do
        <<~HTML
          <button type="button" class="button is-danger"></button>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with label: value' do
      let(:label)   { 'Click Me' }
      let(:options) { super().merge(label: label) }
      let(:snapshot) do
        <<~HTML
          <button type="button" class="button">Click Me</button>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with type: value' do
      let(:type)    { 'submit' }
      let(:options) { super().merge(type: type) }
      let(:snapshot) do
        <<~HTML
          <button type="submit" class="button"></button>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#color' do
    include_examples 'should define reader', :color, nil

    context 'when initialized with color: value' do
      let(:color)   { 'danger' }
      let(:options) { super().merge(color: color) }

      it { expect(button.color).to be == color }
    end
  end

  describe '#label' do
    include_examples 'should define reader', :label, nil

    context 'when initialized with label: value' do
      let(:label)   { 'Click Me' }
      let(:options) { super().merge(label: label) }

      it { expect(button.label).to be == label }
    end
  end

  describe '#type' do
    include_examples 'should define reader', :type, 'button'

    context 'when initialized with type: value' do
      let(:type)    { 'submit' }
      let(:options) { super().merge(type: type) }

      it { expect(button.type).to be == type }
    end
  end
end
