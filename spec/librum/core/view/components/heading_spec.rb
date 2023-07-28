# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::Heading, type: :component do
  subject(:heading) { described_class.new(label, **options) }

  shared_context 'with buttons' do
    let(:buttons) do
      [
        { label: 'Home', url: '/', color: 'info' },
        Librum::Core::View::Components::IdentityComponent.new('Custom Button')
      ]
    end
    let(:options) { super().merge(buttons: buttons) }
  end

  let(:label)   { 'Greetings, Programs' }
  let(:options) { {} }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(1).argument
        .and_keywords(:buttons, :size)
    end
  end

  describe '#buttons' do
    include_examples 'should define reader', :buttons, []

    wrap_context 'with buttons' do
      it { expect(heading.buttons).to be == buttons }
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(heading) }
    let(:snapshot) do
      <<~HTML
        <h1 class="title">Greetings, Programs</h1>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    wrap_context 'with buttons' do
      let(:snapshot) do
        <<~HTML
          <div class="level">
            <div class="level-left">
              <div class="level-item">
                <h1 class="title">Greetings, Programs</h1>
              </div>
            </div>

            <div class="level-right">
              <div class="level-item">
                <a class="button is-info" href="/" target="_self">
                  Home
                </a>
              </div>

              <div class="level-item">
                Custom Button
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    context 'with size' do
      let(:size)    { 3 }
      let(:options) { super().merge(size: size) }
      let(:snapshot) do
        <<~HTML
          <h3 class="title is-3">Greetings, Programs</h3>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#label' do
    include_examples 'should define reader', :label, -> { label }
  end

  describe '#size' do
    include_examples 'should define reader', :size, nil

    context 'when initialized with size: value' do
      let(:size)    { 3 }
      let(:options) { super().merge(size: size) }

      it { expect(heading.size).to be size }
    end
  end
end
