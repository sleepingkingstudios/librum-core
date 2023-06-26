# frozen_string_literal: true

require 'rails_helper'

require 'librum/core/view/components/missing_component'

RSpec.describe Librum::Core::View::Components::MissingComponent,
  type: :component \
do
  subject(:component) { described_class.new(**constructor_options) }

  let(:name)                { 'Launch Pad' }
  let(:constructor_options) { { name: name } }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:icon, :label, :message, :name)
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(component) }
    let(:snapshot) do
      <<~HTML
        <div class="box">
          <p class="has-text-centered">
            <span class="icon is-large has-text-danger">
              <i class="fas fa-2x fa-bug"></i>
            </span>
          </p>

          <h2 class="title has-text-centered has-text-danger">Missing Component Launch Pad</h2>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with icon: value' do
      let(:constructor_options) { super().merge(icon: 'rocket') }
      let(:snapshot) do
        <<~HTML
          <div class="box">
            <p class="has-text-centered">
              <span class="icon is-large has-text-danger">
                <i class="fas fa-2x fa-rocket"></i>
              </span>
            </p>

            <h2 class="title has-text-centered has-text-danger">Missing Component Launch Pad</h2>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with label: value' do
      let(:label)               { 'T-Minus 10, 9, 8...' }
      let(:constructor_options) { super().merge(label: label) }
      let(:snapshot) do
        <<~HTML
          <div class="box">
            <p class="has-text-centered">
              <span class="icon is-large has-text-danger">
                <i class="fas fa-2x fa-bug"></i>
              </span>
            </p>

            <h2 class="title has-text-centered has-text-danger">T-Minus 10, 9, 8...</h2>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with message: value' do
      let(:message)             { 'Expected Launch Site: KSC' }
      let(:constructor_options) { super().merge(message: message) }
      let(:snapshot) do
        <<~HTML
          <div class="box">
            <p class="has-text-centered">
              <span class="icon is-large has-text-danger">
                <i class="fas fa-2x fa-bug"></i>
              </span>
            </p>

            <h2 class="title has-text-centered has-text-danger">Missing Component Launch Pad</h2>

            <p class="has-text-centered">Expected Launch Site: KSC</p>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#icon' do
    include_examples 'should define reader', :icon, 'bug'

    context 'when initialized with icon: value' do
      let(:constructor_options) { super().merge(icon: 'rocket') }

      it { expect(component.icon).to be == 'rocket' }
    end
  end

  describe '#label' do
    let(:expected) { "Missing Component #{name}" }

    include_examples 'should define reader', :label, -> { expected }

    context 'when initialized with message: value' do
      let(:label)               { 'T-Minus 10, 9, 8...' }
      let(:constructor_options) { super().merge(label: label) }

      it { expect(component.label).to be == label }
    end
  end

  describe '#message' do
    include_examples 'should define reader', :message, nil

    context 'when initialized with message: value' do
      let(:message)             { 'Expected Launch Site: KSC' }
      let(:constructor_options) { super().merge(message: message) }

      it { expect(component.message).to be == message }
    end
  end

  describe '#name' do
    include_examples 'should define reader', :name, -> { name }
  end
end
