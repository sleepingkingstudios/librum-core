# frozen_string_literal: true

require 'rails_helper'

require 'stannum/errors'

RSpec.describe Librum::Core::View::Components::FormSelect, type: :component do
  subject(:component) { described_class.new(name, **constructor_options) }

  shared_context 'with options' do
    let(:items) do
      [
        {
          label: 'KSC',
          value: '0'
        },
        {
          separator: true
        },
        {
          label: 'Baikerbanur',
          value: '1'
        }
      ]
    end
  end

  shared_context 'with option groups' do
    let(:items) do
      [
        {
          label: 'Kerbin',
          items: [
            {
              label: 'KSC',
              value: '0'
            },
            {
              separator: true
            },
            {
              label: 'Baikerbanur',
              value: '1'
            }
          ]
        },
        {
          label: 'The Mun',
          items: [
            {
              label: 'Armstrong Base',
              value: 2
            }
          ]
        }
      ]
    end
  end

  let(:name)                { 'launch_site' }
  let(:items)               { [] }
  let(:constructor_options) { { items: items } }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(1).argument
        .and_keywords(:error_key, :errors, :id, :items, :value)
        .and_any_keywords
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(component) }
    let(:snapshot) do
      <<~HTML
        <div class="select">
          <select name="launch_site">
          </select>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with disabled: true' do
      let(:constructor_options) { super().merge(disabled: true) }
      let(:snapshot) do
        <<~HTML
          <div class="select">
            <select name="launch_site" disabled="disabled">
            </select>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with errors: an empty Array' do
      let(:errors)              { [] }
      let(:constructor_options) { super().merge(errors: errors) }

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with errors: a non-empty Array' do
      let(:errors)              { ["can't be blank"] }
      let(:constructor_options) { super().merge(errors: errors) }
      let(:snapshot) do
        <<~HTML
          <div class="select is-danger">
            <select name="launch_site">
            </select>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with id: value' do
      let(:name)                { 'rocket[launch_site]' }
      let(:id)                  { 'rocket_launch_site' }
      let(:constructor_options) { super().merge(id: id) }
      let(:snapshot) do
        <<~HTML
          <div class="select">
            <select name="rocket[launch_site]" id="rocket_launch_site">
            </select>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with include_blank: true' do
      let(:constructor_options) { super().merge(include_blank: true) }
      let(:snapshot) do
        <<~HTML
          <div class="select">
            <select name="launch_site">
              <option value=""> </option>
            </select>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with value: value' do
      let(:constructor_options) { super().merge(value: 1) }

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    wrap_context 'with options' do
      let(:snapshot) do
        <<~HTML
          <div class="select">
            <select name="launch_site">
              <option value="0">KSC</option>

              <option disabled="disabled"> </option>

              <option value="1">Baikerbanur</option>
            </select>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with include_blank: true' do
        let(:constructor_options) { super().merge(include_blank: true) }
        let(:snapshot) do
          <<~HTML
            <div class="select">
              <select name="launch_site">
                <option value=""> </option>

                <option value="0">KSC</option>

                <option disabled="disabled"> </option>

                <option value="1">Baikerbanur</option>
              </select>
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with value: value' do
        let(:constructor_options) { super().merge(value: 1) }
        let(:snapshot) do
          <<~HTML
            <div class="select">
              <select name="launch_site">
                <option value="0">KSC</option>

                <option disabled="disabled"> </option>

                <option value="1" selected="selected">Baikerbanur</option>
              </select>
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    wrap_context 'with option groups' do
      let(:snapshot) do
        <<~HTML
          <div class="select">
            <select name="launch_site">
              <optgroup label="Kerbin">
                <option value="0">KSC</option>

                <option disabled="disabled"> </option>

                <option value="1">Baikerbanur</option>
              </optgroup>

              <optgroup label="The Mun">
                <option value="2">Armstrong Base</option>
              </optgroup>
            </select>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with include_blank: true' do
        let(:constructor_options) { super().merge(include_blank: true) }
        let(:snapshot) do
          <<~HTML
            <div class="select">
              <select name="launch_site">
                <option value=""> </option>

                <optgroup label="Kerbin">
                  <option value="0">KSC</option>

                  <option disabled="disabled"> </option>

                  <option value="1">Baikerbanur</option>
                </optgroup>

                <optgroup label="The Mun">
                  <option value="2">Armstrong Base</option>
                </optgroup>
              </select>
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with value: value' do
        let(:constructor_options) { super().merge(value: 1) }
        let(:snapshot) do
          <<~HTML
            <div class="select">
              <select name="launch_site">
                <optgroup label="Kerbin">
                  <option value="0">KSC</option>

                  <option disabled="disabled"> </option>

                  <option value="1" selected="selected">Baikerbanur</option>
                </optgroup>

                <optgroup label="The Mun">
                  <option value="2">Armstrong Base</option>
                </optgroup>
              </select>
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end
  end

  describe '#disabled?' do
    include_examples 'should define predicate', :disabled?, false

    context 'when initialized with disabled: false' do
      let(:constructor_options) { super().merge(disabled: false) }

      it { expect(component.disabled?).to be false }
    end

    context 'when initialized with disabled: true' do
      let(:constructor_options) { super().merge(disabled: true) }

      it { expect(component.disabled?).to be true }
    end
  end

  describe '#error_key' do
    include_examples 'should define reader', :error_key, -> { name }

    context 'when initialized with error_key: value' do
      let(:error_key)             { 'user_name' }
      let(:constructor_options)   { super().merge(error_key: error_key) }

      it { expect(component.error_key).to be == error_key }
    end
  end

  describe '#errors' do
    include_examples 'should define reader', :errors, nil

    context 'when initialized with errors: value' do
      let(:errors)              { ["can't be blank"] }
      let(:constructor_options) { super().merge(errors: errors) }

      it { expect(component.errors).to be == errors }
    end
  end

  describe '#id' do
    include_examples 'should define reader', :id, nil

    context 'when initialized with id: value' do
      let(:id)                  { 'launch_site' }
      let(:constructor_options) { super().merge(id: id) }

      it { expect(component.id).to be == id }
    end
  end

  describe '#include_blank?' do
    include_examples 'should define predicate', :include_blank?, false

    context 'when initialized with include_blank: false' do
      let(:constructor_options) { super().merge(include_blank: false) }

      it { expect(component.include_blank?).to be false }
    end

    context 'when initialized with include_blank: true' do
      let(:constructor_options) { super().merge(include_blank: true) }

      it { expect(component.include_blank?).to be true }
    end
  end

  describe '#items' do
    include_examples 'should define reader', :items, -> { items }

    wrap_context 'with options' do # rubocop:disable RSpec/RepeatedExampleGroupBody
      it { expect(component.items).to be == items }
    end

    wrap_context 'with option groups' do # rubocop:disable RSpec/RepeatedExampleGroupBody
      it { expect(component.items).to be == items }
    end
  end

  describe '#matching_errors' do
    include_examples 'should define reader', :matching_errors, []

    context 'when initialized with errors: an Array' do
      let(:errors)              { ["can't be blank"] }
      let(:constructor_options) { super().merge(errors: errors) }

      it { expect(component.matching_errors).to be == errors }
    end

    context 'when initialized with errors: an errors object' do
      let(:errors)              { Stannum::Errors.new }
      let(:constructor_options) { super().merge(errors: errors) }

      it { expect(component.matching_errors).to be == [] }

      context 'when the errors object has non-matching errors' do
        let(:errors) do
          super().tap do |err|
            err['custom'].add('spec.error', message: "can't be blank")
          end
        end

        it { expect(component.matching_errors).to be == [] }
      end

      context 'when the errors object has matching errors' do
        let(:errors) do
          super().tap do |err|
            err[name].add('spec.error', message: "can't be blank")
          end
        end

        it { expect(component.matching_errors).to be == ["can't be blank"] }
      end

      context 'when initialized with error_key: value' do
        let(:error_key)           { 'user_name' }
        let(:constructor_options) { super().merge(error_key: error_key) }

        it { expect(component.matching_errors).to be == [] }

        context 'when the errors object has matching errors' do
          let(:errors) do
            super().tap do |err|
              err[error_key].add('spec.error', message: "can't be blank")
            end
          end

          it { expect(component.matching_errors).to be == ["can't be blank"] }
        end
      end
    end
  end

  describe '#name' do
    include_examples 'should define reader', :name, -> { name }
  end

  describe '#options' do
    include_examples 'should define reader', :options, -> { {} }

    context 'when initialized with disabled: false' do
      let(:constructor_options) { super().merge(disabled: false) }

      it { expect(component.options).to be == { disabled: false } }
    end

    context 'when initialized with disabled: true' do
      let(:constructor_options) { super().merge(disabled: true) }

      it { expect(component.options).to be == { disabled: true } }
    end

    context 'when initialized with include_blank: false' do
      let(:constructor_options) { super().merge(include_blank: false) }

      it { expect(component.options).to be == { include_blank: false } }
    end

    context 'when initialized with include_blank: true' do
      let(:constructor_options) { super().merge(include_blank: true) }

      it { expect(component.options).to be == { include_blank: true } }
    end

    context 'when initialized with custom options' do
      let(:constructor_options) { super().merge(custom: 'value') }

      it { expect(component.options).to be == { custom: 'value' } }
    end
  end

  describe '#value' do
    include_examples 'should define reader', :value, nil

    context 'when initialized with value: a String' do
      let(:value)               { 'Alan Bradley' }
      let(:constructor_options) { super().merge(value: value) }

      it { expect(component.value).to be == value }
    end
  end
end
