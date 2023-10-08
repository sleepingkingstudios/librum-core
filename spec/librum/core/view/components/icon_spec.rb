# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::Icon, type: :component do
  subject(:component) { described_class.new(**options) }

  let(:icon)    { 'radiation' }
  let(:options) { { icon: icon } }

  describe '.new' do
    let(:expected_keywords) do
      %i[
        animation
        bordered
        class_name
        color
        fixed_width
        icon
        size
      ]
    end

    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(*expected_keywords)
    end
  end

  describe '#animation' do
    include_examples 'should define reader', :animation, nil

    context 'when initialized with animation: value' do
      let(:animation) { 'pulse' }
      let(:options)   { super().merge(animation: animation) }

      it { expect(component.animation).to be == animation }
    end
  end

  describe '#bordered?' do
    include_examples 'should define predicate', :bordered?, false

    context 'when initialized with bordered: false' do
      let(:options) { super().merge(bordered: false) }

      it { expect(component.bordered?).to be false }
    end

    context 'when initialized with bordered: true' do
      let(:options) { super().merge(bordered: true) }

      it { expect(component.bordered?).to be true }
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(component) }
    let(:snapshot) do
      <<~HTML
        <span class="icon">
          <i class="fas fa-radiation"></i>
        </span>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    context 'when initialized with animation: value' do
      let(:animation) { 'pulse' }
      let(:options)   { super().merge(animation: animation) }
      let(:snapshot) do
        <<~HTML
          <span class="icon">
            <i class="fas fa-radiation fa-pulse"></i>
          </span>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    context 'when initialized with bordered: true' do
      let(:options) { super().merge(bordered: true) }
      let(:snapshot) do
        <<~HTML
          <span class="icon">
            <i class="fas fa-radiation fa-border"></i>
          </span>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    context 'when initialized with class_name: an Array' do
      let(:class_name) { %w[is-left is-unselectable] }
      let(:options)    { super().merge(class_name: class_name) }
      let(:snapshot) do
        <<~HTML
          <span class="icon is-left is-unselectable">
            <i class="fas fa-radiation"></i>
          </span>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    context 'when initialized with class_name: a String' do
      let(:class_name) { 'is-left' }
      let(:options)    { super().merge(class_name: class_name) }
      let(:snapshot) do
        <<~HTML
          <span class="icon is-left">
            <i class="fas fa-radiation"></i>
          </span>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    context 'when initialized with color: value' do
      let(:color)   { 'danger' }
      let(:options) { super().merge(color: color) }
      let(:snapshot) do
        <<~HTML
          <span class="icon has-text-danger">
            <i class="fas fa-radiation"></i>
          </span>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    context 'when initialized with fixed_width: true' do
      let(:options) { super().merge(fixed_width: true) }
      let(:snapshot) do
        <<~HTML
          <span class="icon">
            <i class="fas fa-radiation fa-fw"></i>
          </span>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    context 'when initialized with size: small' do
      let(:size)    { 'small' }
      let(:options) { super().merge(size: size) }
      let(:snapshot) do
        <<~HTML
          <span class="icon is-small">
            <i class="fas fa-radiation"></i>
          </span>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    context 'when initialized with size: medium' do
      let(:size)    { 'medium' }
      let(:options) { super().merge(size: size) }
      let(:snapshot) do
        <<~HTML
          <span class="icon is-medium">
            <i class="fas fa-radiation fa-lg"></i>
          </span>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    context 'when initialized with size: large' do
      let(:size)    { 'large' }
      let(:options) { super().merge(size: size) }
      let(:snapshot) do
        <<~HTML
          <span class="icon is-large">
            <i class="fas fa-radiation fa-2x"></i>
          </span>
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

      it { expect(component.color).to be == color }
    end
  end

  describe '#class_name' do
    include_examples 'should define reader', :class_name, []

    context 'when initialized with class_name: an Array' do
      let(:class_name) { %w[is-left is-unselectable] }
      let(:options)    { super().merge(class_name: class_name) }

      it { expect(component.class_name).to be == class_name }
    end

    context 'when initialized with class_name: a String' do
      let(:class_name) { 'is-left' }
      let(:options)    { super().merge(class_name: class_name) }

      it { expect(component.class_name).to be == Array(class_name) }
    end
  end

  describe '#fixed_width?' do
    include_examples 'should define predicate', :fixed_width?, false

    context 'when initialized with fixed_width: false' do
      let(:options) { super().merge(fixed_width: false) }

      it { expect(component.fixed_width?).to be false }
    end

    context 'when initialized with fixed_width: true' do
      let(:options) { super().merge(fixed_width: true) }

      it { expect(component.options).to be == { fixed_width: true } }
    end
  end

  describe '#icon' do
    include_examples 'should define reader', :icon, -> { icon }
  end

  describe '#options' do
    include_examples 'should define reader', :options, -> { {} }

    context 'when initialized with animation: value' do
      let(:animation) { 'pulse' }
      let(:options)   { super().merge(animation: animation) }

      it { expect(component.options).to be == { animation: animation } }
    end

    context 'when initialized with bordered: false' do
      let(:options) { super().merge(bordered: false) }

      it { expect(component.options).to be == { bordered: false } }
    end

    context 'when initialized with bordered: true' do
      let(:options) { super().merge(bordered: true) }

      it { expect(component.options).to be == { bordered: true } }
    end

    context 'when initialized with class_name: an Array' do
      let(:class_name) { %w[is-left is-unselectable] }
      let(:options)    { super().merge(class_name: class_name) }

      it { expect(component.options).to be == { class_name: class_name } }
    end

    context 'when initialized with class_name: a String' do
      let(:class_name) { 'is-left' }
      let(:options)    { super().merge(class_name: class_name) }

      it { expect(component.options).to be == { class_name: class_name } }
    end

    context 'when initialized with fixed_width: false' do
      let(:options) { super().merge(fixed_width: false) }

      it { expect(component.options).to be == { fixed_width: false } }
    end

    context 'when initialized with fixed_width: true' do
      let(:options) { super().merge(fixed_width: true) }

      it { expect(component.options).to be == { fixed_width: true } }
    end

    context 'when initialized with custom options' do
      let(:options) { super().merge(custom: 'value') }

      it { expect(component.options).to be == { custom: 'value' } }
    end
  end

  describe '#size' do
    include_examples 'should define reader', :size, nil

    context 'when initialized with size: value' do
      let(:size)    { 'large' }
      let(:options) { super().merge(size: size) }

      it { expect(component.size).to be == size }
    end
  end
end
