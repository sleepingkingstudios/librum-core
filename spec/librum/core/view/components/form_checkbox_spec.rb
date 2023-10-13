# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::FormCheckbox, type: :component \
do
  include Librum::Core::RSpec::Contracts::ComponentContracts

  subject(:component) { described_class.new(name, **options) }

  let(:name)     { 'admin' }
  let(:options)  { {} }

  describe '.new' do
    let(:expected_keywords) do
      %i[
        checked
        class_name
        disabled
        errors
        error_key
        id
        label
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

  include_contract 'should define class name option'

  describe '#call' do
    let(:rendered) { render_inline(component) }
    let(:snapshot) do
      <<~HTML
        <label class="checkbox" name="admin">
          <input autocomplete="off" name="admin" type="hidden" value="0">

          <input name="admin" type="checkbox" value="1">
        </label>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with checked: false' do
      let(:options) { super().merge(checked: false) }

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with checked: true' do
      let(:options) { super().merge(checked: true) }
      let(:snapshot) do
        <<~HTML
          <label class="checkbox" name="admin">
            <input autocomplete="off" name="admin" type="hidden" value="0">

            <input name="admin" type="checkbox" value="1" checked>
          </label>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with class_name: value' do
      let(:options) { super().merge(class_name: 'is-uppercase') }
      let(:snapshot) do
        <<~HTML
          <label class="checkbox is-uppercase" name="admin">
            <input autocomplete="off" name="admin" type="hidden" value="0">

            <input name="admin" type="checkbox" value="1">
          </label>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with disabled: false' do
      let(:options) { super().merge(disabled: false) }

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with disabled: true' do
      let(:options) { super().merge(disabled: true) }
      let(:snapshot) do
        <<~HTML
          <label class="checkbox" name="admin" disabled="disabled">
            <input autocomplete="off" name="admin" type="hidden" value="0">

            <input name="admin" type="checkbox" value="1" disabled>
          </label>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with errors: a non-empty Array' do
      let(:errors)  { ["can't be blank"] }
      let(:options) { super().merge(errors: errors) }
      let(:snapshot) do
        <<~HTML
          <label class="checkbox has-text-danger" name="admin">
            <input autocomplete="off" name="admin" type="hidden" value="0">

            <input name="admin" type="checkbox" value="1">
          </label>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with id: value' do
      let(:name)    { 'user[admin]' }
      let(:id)      { 'user_admin' }
      let(:options) { super().merge(id: id) }
      let(:snapshot) do
        <<~HTML
          <label class="checkbox" name="user[admin]" for="user_admin">
            <input autocomplete="off" name="user[admin]" type="hidden" value="0">

            <input name="user[admin]" type="checkbox" value="1" id="user_admin">
          </label>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with label: a Component' do
      let(:label) do
        Librum::Core::View::Components::MockComponent.new('label')
      end
      let(:options) { super().merge(label: label) }
      let(:snapshot) do
        <<~HTML
          <label class="checkbox" name="admin">
            <input autocomplete="off" name="admin" type="hidden" value="0">

            <input name="admin" type="checkbox" value="1">

            <mock name="label"></mock>
          </label>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with label: a String' do
      let(:options) { super().merge(label: 'Admin?') }
      let(:snapshot) do
        <<~HTML
          <label class="checkbox" name="admin">
            <input autocomplete="off" name="admin" type="hidden" value="0">

            <input name="admin" type="checkbox" value="1">

            Admin?
          </label>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#checked?' do
    include_examples 'should define predicate', :checked?, false

    context 'when initialized with checked: false' do
      let(:options) { super().merge(checked: false) }

      it { expect(component.checked?).to be false }
    end

    context 'when initialized with checked: true' do
      let(:options) { super().merge(checked: true) }

      it { expect(component.checked?).to be true }
    end
  end

  describe '#id' do
    include_examples 'should define reader', :id, nil

    context 'when initialized with id: value' do
      let(:options) { super().merge(id: 'user_admin') }

      it { expect(component.id).to be == 'user_admin' }
    end
  end

  describe '#label' do
    include_examples 'should define reader', :label, nil

    context 'when initialized with label: a Component' do
      let(:label) do
        Librum::Core::View::Components::MockComponent.new('label')
      end
      let(:options) { super().merge(label: label) }

      it { expect(component.label).to be label }
    end

    context 'when initialized with label: a String' do
      let(:options) { super().merge(label: 'Admin?') }

      it { expect(component.label).to be == 'Admin?' }
    end
  end

  describe '#name' do
    include_examples 'should define reader', :name, -> { name }
  end
end
