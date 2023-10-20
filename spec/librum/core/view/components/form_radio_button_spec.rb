# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::FormRadioButton, \
  type: :component \
do
  include Librum::Core::RSpec::Contracts::ComponentContracts

  subject(:component) { described_class.new(name, **options) }

  let(:name)    { 'launch_site' }
  let(:options) { {} }

  describe '.new' do
    let(:expected_keywords) do
      %i[
        checked
        class_name
        disabled
        error_key
        errors
        id
        label
        value
      ]
    end

    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(1).argument
        .and_keywords(*expected_keywords)
    end
  end

  include_contract 'should define options'

  include_contract 'should define class name option'

  include_contract 'should define option', :checked?, boolean: true

  include_contract 'should define option', :disabled?, boolean: true

  include_contract 'should define option', :error_key, default: -> { name }

  include_contract 'should define option', :errors

  include_contract 'should define option', :id

  include_contract 'should define option', :label

  include_contract 'should define option', :value

  describe '#call' do
    let(:rendered) { render_inline(component) }
    let(:snapshot) do
      <<~HTML
        <label class="radio" name="launch_site">
          <input name="launch_site" type="radio">
        </label>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with checked: true' do
      let(:options) { super().merge(checked: true) }
      let(:snapshot) do
        <<~HTML
          <label class="radio" name="launch_site">
            <input name="launch_site" type="radio" checked>
          </label>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with class_name: value' do
      let(:options) { super().merge(class_name: 'is-uppercase') }
      let(:snapshot) do
        <<~HTML
          <label class="radio is-uppercase" name="launch_site">
            <input name="launch_site" type="radio">
          </label>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with disabled: true' do
      let(:options) { super().merge(disabled: true) }
      let(:snapshot) do
        <<~HTML
          <label class="radio" name="launch_site" disabled="disabled">
            <input name="launch_site" type="radio" disabled>
          </label>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with errors: an empty Array' do
      let(:options) { super().merge(errors: []) }

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with errors: a non-empty Array' do
      let(:options) { super().merge(errors: ['is invalid']) }
      let(:snapshot) do
        <<~HTML
          <label class="radio has-text-danger" name="launch_site">
            <input name="launch_site" type="radio">
          </label>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with id: value' do
      let(:name)    { 'rocket[launch_site]' }
      let(:id)      { 'rocket_launch_site' }
      let(:options) { super().merge(id: id) }
      let(:snapshot) do
        <<~HTML
          <label class="radio" name="rocket[launch_site]" for="rocket_launch_site">
            <input name="rocket[launch_site]" type="radio" id="rocket_launch_site">
          </label>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with label: value' do
      let(:options) { super().merge(label: 'Launch Site') }
      let(:snapshot) do
        <<~HTML
          <label class="radio" name="launch_site">
            <input name="launch_site" type="radio">

            Launch Site
          </label>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with value: value' do
      let(:options) { super().merge(value: 'KSC') }
      let(:snapshot) do
        <<~HTML
          <label class="radio" name="launch_site">
            <input name="launch_site" type="radio" value="KSC">
          </label>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#name' do
    include_examples 'should define reader', :name, -> { name }
  end
end
