# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::FormTextArea, type: :component do
  include Librum::Core::RSpec::Contracts::ComponentContracts

  subject(:component) { described_class.new(name, **options) }

  let(:name)     { 'details' }
  let(:options)  { {} }

  describe '.new' do
    let(:expected_keywords) do
      %i[
        disabled
        error_key
        errors
        id
        placeholder
        rows
        value
      ]
    end

    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(1).argument
        .and_keywords(*expected_keywords)
        .and_any_keywords
    end
  end

  include_contract 'should define options'

  include_contract 'should define option', :disabled?, boolean: true

  include_contract 'should define option', :error_key, default: -> { name }

  include_contract 'should define option', :errors

  include_contract 'should define option', :placeholder

  include_contract 'should define option', :rows

  describe '#call' do
    let(:rendered) { render_inline(component) }
    let(:snapshot) do
      <<~HTML
        <textarea class="textarea" name="details"></textarea>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with disabled: true' do
      let(:options) { super().merge(disabled: true) }
      let(:snapshot) do
        <<~HTML
          <textarea class="textarea" name="details" disabled></textarea>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with errors: an empty Array' do
      let(:errors)  { [] }
      let(:options) { super().merge(errors: errors) }

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with errors: a non-empty Array' do
      let(:errors)  { ["can't be blank"] }
      let(:options) { super().merge(errors: errors) }
      let(:snapshot) do
        <<~HTML
          <textarea class="textarea is-danger" name="details"></textarea>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with id: value' do
      let(:id)      { 'user_details' }
      let(:name)    { 'user[details]' }
      let(:options) { super().merge(id: id) }
      let(:snapshot) do
        <<~HTML
          <textarea class="textarea" name="user[details]" id="user_details"></textarea>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with placeholder: value' do
      let(:placeholder) { 'Enter user details...' }
      let(:options)     { super().merge(placeholder: placeholder) }
      let(:snapshot) do
        <<~HTML
          <textarea class="textarea" name="details" placeholder="Enter user details..."></textarea>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with rows: value' do
      let(:options) { super().merge(rows: 10) }
      let(:snapshot) do
        <<~HTML
          <textarea class="textarea" name="details" rows="10"></textarea>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with value: value' do
      let(:value)   { 'User is [Classified]' }
      let(:options) { super().merge(value: value) }
      let(:snapshot) do
        <<~HTML
          <textarea class="textarea" name="details">User is [Classified]</textarea>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#id' do
    include_examples 'should define reader', :id, nil

    context 'when initialized with id: value' do
      let(:id)      { 'user_details' }
      let(:name)    { 'user[details]' }
      let(:options) { super().merge(id: id) }

      it { expect(component.id).to be == id }
    end
  end

  describe '#name' do
    include_examples 'should define reader', :name, -> { name }
  end

  describe '#value' do
    include_examples 'should define reader', :value, nil

    context 'when initialized with value: value' do
      let(:value)   { 'A straight shot to upper management.' }
      let(:options) { super().merge(value: value) }

      it { expect(component.value).to be == value }
    end
  end
end
