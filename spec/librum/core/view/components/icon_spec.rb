# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::Icon, type: :component do
  include Librum::Core::RSpec::Contracts::ComponentContracts

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
        .and_any_keywords
    end
  end

  include_contract 'should define options'

  include_contract 'should define option', :animation

  include_contract 'should define option', :bordered?, boolean: true

  include_contract 'should define option', :color

  include_contract 'should define option', :fixed_width?, boolean: true

  include_contract 'should define option', :size

  include_contract 'should define class name option'

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

  describe '#icon' do
    include_examples 'should define reader', :icon, -> { icon }
  end
end
