# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::MockComponent, type: :component \
do
  subject(:mock) { described_class.new(name, **options) }

  let(:name)    { 'custom' }
  let(:options) { {} }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(1).argument
        .and_any_keywords
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(mock) }
    let(:snapshot) do
      <<~HTML
        <mock name="custom"></mock>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with options: value' do
      let(:options) { { key: 'value', option: true } }
      let(:snapshot) do
        <<~HTML
          <mock name="custom" key="value" option="true"></mock>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#options' do
    include_examples 'should define reader', :options, {}

    context 'when initialized with options: value' do
      let(:options) { { key: 'value', option: true } }

      it { expect(mock.options).to be == options }
    end
  end
end
