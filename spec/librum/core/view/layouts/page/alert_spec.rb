# frozen_string_literal: true

require 'rails_helper'

require 'librum/core/view/layouts/page/alert'

RSpec.describe Librum::Core::View::Layouts::Page::Alert, type: :component do
  subject(:alert) { described_class.new(message, **options) }

  let(:message)  { 'Reactor temperature critical' }
  let(:options)  { {} }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(1).argument
        .and_keywords(:color, :icon)
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(alert) }
    let(:snapshot) do
      <<~HTML
        <div class="notification">
          Reactor temperature critical
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with color: value' do
      let(:color)   { 'danger' }
      let(:options) { super().merge(color: color) }
      let(:snapshot) do
        <<~HTML
          <div class="notification is-danger">
            Reactor temperature critical
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with icon: value' do
      let(:icon)    { 'radiation' }
      let(:options) { super().merge(icon: icon) }
      let(:snapshot) do
        <<~HTML
          <div class="notification">
            <span class="icon-text">
              <span class="icon">
                <i class="fas fa-radiation"></i>
              </span>

              <span>Reactor temperature critical</span>
            </span>
          </div>
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

      it { expect(alert.color).to be == color }
    end
  end

  describe '#icon' do
    include_examples 'should define reader', :icon, nil

    context 'when initialized with color: value' do
      let(:icon)    { 'radiation' }
      let(:options) { super().merge(icon: icon) }

      it { expect(alert.icon).to be == icon }
    end
  end

  describe '#message' do
    include_examples 'should define reader', :message, -> { message }
  end
end
