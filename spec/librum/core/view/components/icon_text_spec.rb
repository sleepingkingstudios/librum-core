# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::IconText, type: :component do
  subject(:component) { described_class.new(icon: icon, label: label) }

  let(:icon)  { 'radiation' }
  let(:label) { 'Reactor temperature critical' }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:icon, :label)
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(component) }
    let(:snapshot) do
      <<~HTML
        <span class="icon-text">
          <span class="icon">
            <i class="fas fa-radiation"></i>
          </span>

          <span>Reactor temperature critical</span>
        </span>
      HTML
    end

    it 'should match the snapshot' do
      expect(rendered).to match_snapshot(snapshot)
    end

    describe 'with icon: nil' do
      let(:icon) { nil }
      let(:snapshot) do
        <<~HTML
          Reactor temperature critical
        HTML
      end

      it 'should match the snapshot' do
        expect(rendered).to match_snapshot(snapshot)
      end
    end

    describe 'with icon: an empty string' do
      let(:icon) { '' }
      let(:snapshot) do
        <<~HTML
          Reactor temperature critical
        HTML
      end

      it 'should match the snapshot' do
        expect(rendered).to match_snapshot(snapshot)
      end
    end

    describe 'with label: nil' do
      let(:label) { nil }
      let(:snapshot) do
        <<~HTML
          <span class="icon">
            <i class="fas fa-radiation"></i>
          </span>
        HTML
      end

      it 'should match the snapshot' do
        expect(rendered).to match_snapshot(snapshot)
      end
    end

    describe 'with label: an empty string' do
      let(:label) { '' }
      let(:snapshot) do
        <<~HTML
          <span class="icon">
            <i class="fas fa-radiation"></i>
          </span>
        HTML
      end

      it 'should match the snapshot' do
        expect(rendered).to match_snapshot(snapshot)
      end
    end
  end

  describe '#icon' do
    include_examples 'should define reader', :icon, -> { icon }
  end

  describe '#label' do
    include_examples 'should define reader', :label, -> { label }
  end
end
