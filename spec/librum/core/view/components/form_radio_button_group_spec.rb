# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::FormRadioButtonGroup, \
  type: :component \
do
  include Librum::Core::RSpec::Contracts::ComponentContracts

  subject(:component) { described_class.new(name, **options) }

  let(:name) { 'launch_site' }
  let(:items) do
    [
      { label: 'KSC', value: 'KSC' },
      { value: 'baikerbanur' }
    ]
  end
  let(:options) { { items: items } }

  describe '.new' do
    let(:expected_keywords) do
      %i[
        class_name
        data
        error_key
        errors
        items
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

  include_contract 'should define option', :error_key, default: -> { name }

  include_contract 'should define option', :errors

  include_contract 'should define option', :label, default: -> { name.titleize }

  describe '#call' do
    let(:rendered) { render_inline(component) }
    let(:snapshot) do
      <<~HTML
        <div class="field">
          <label class="label">Launch Site</label>

          <div class="control">
            <div class="columns">
              <div class="column">
                <label class="radio" name="launch_site">
                  <input name="launch_site" type="radio" value="KSC">

                  KSC
                </label>
              </div>

              <div class="column">
                <label class="radio" name="launch_site">
                  <input name="launch_site" type="radio" value="baikerbanur">

                  Baikerbanur
                </label>
              </div>
            </div>
          </div>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with class_name: value' do
      let(:options) { super().merge(class_name: 'is-uppercase') }
      let(:snapshot) do
        <<~HTML
          <div class="field is-uppercase">
            <label class="label">Launch Site</label>

            <div class="control">
              <div class="columns">
                <div class="column">
                  <label class="radio" name="launch_site">
                    <input name="launch_site" type="radio" value="KSC">

                    KSC
                  </label>
                </div>

                <div class="column">
                  <label class="radio" name="launch_site">
                    <input name="launch_site" type="radio" value="baikerbanur">

                    Baikerbanur
                  </label>
                </div>
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with errors: an empty Array' do
      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with errors: a non-empty Array' do
      let(:options) { super().merge(errors: ['is invalid']) }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label class="label">Launch Site</label>

            <div class="control has-icons-right">
              <div class="columns">
                <div class="column">
                  <label class="radio has-text-danger" name="launch_site">
                    <input name="launch_site" type="radio" value="KSC">

                    KSC
                  </label>
                </div>

                <div class="column">
                  <label class="radio has-text-danger" name="launch_site">
                    <input name="launch_site" type="radio" value="baikerbanur">

                    Baikerbanur
                  </label>
                </div>
              </div>

              <span class="icon is-right is-small">
                <i class="fas fa-triangle-exclamation"></i>
              </span>
            </div>

            <p class="help is-danger">is invalid</p>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with label: value' do
      let(:options) { super().merge(label: 'Launch From:') }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label class="label">Launch From:</label>

            <div class="control">
              <div class="columns">
                <div class="column">
                  <label class="radio" name="launch_site">
                    <input name="launch_site" type="radio" value="KSC">

                    KSC
                  </label>
                </div>

                <div class="column">
                  <label class="radio" name="launch_site">
                    <input name="launch_site" type="radio" value="baikerbanur">

                    Baikerbanur
                  </label>
                </div>
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with value: value' do
      let(:options) { super().merge(value: 'baikerbanur') }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label class="label">Launch Site</label>

            <div class="control">
              <div class="columns">
                <div class="column">
                  <label class="radio" name="launch_site">
                    <input name="launch_site" type="radio" value="KSC">

                    KSC
                  </label>
                </div>

                <div class="column">
                  <label class="radio" name="launch_site">
                    <input name="launch_site" type="radio" value="baikerbanur" checked>

                    Baikerbanur
                  </label>
                </div>
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#items' do
    include_examples 'should define reader', :items, -> { items }
  end

  describe '#label' do
    context 'when initialized with name: scoped String' do
      let(:name) { 'rocket[launch_site]' }

      it { expect(component.label).to be == 'Launch Site' }
    end
  end

  describe '#name' do
    include_examples 'should define reader', :name, -> { name }
  end

  describe '#value' do
    include_examples 'should define reader', :value, nil

    context 'when initialized with data: matching data' do
      let(:name)    { 'rocket[launch_site]' }
      let(:data)    { { 'rocket' => { 'launch_site' => 'KSC' } } }
      let(:options) { super().merge(data: data) }

      it { expect(component.value).to be == 'KSC' }
    end

    context 'when initialized with value: value' do
      let(:options) { super().merge(value: 'KSC') }

      it { expect(component.value).to be == 'KSC' }
    end
  end
end
