# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::FormField, type: :component do
  subject(:field) { described_class.new(name, **options) }

  let(:name)    { 'color' }
  let(:options) { {} }

  example_class 'Spec::Rocket', Struct.new(:name, :color, keyword_init: true)

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(1).argument
        .and_keywords(:errors, :icon, :label, :type)
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(field) }
    let(:snapshot) do
      <<~HTML
        <div class="field">
          <label for="color" class="label">Color</label>

          <div class="control">
            <input id="color" name="color" class="input" type="text">
          </div>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with data: value' do
      let(:data)    { { 'color' => 'red' } }
      let(:options) { super().merge(data: data) }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label for="color" class="label">Color</label>

            <div class="control">
              <input id="color" name="color" class="input" type="text" value="red">
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with value: value' do
        let(:value)   { 'Custom Value' }
        let(:options) { super().merge(value: value) }
        let(:snapshot) do
          <<~HTML
            <div class="field">
              <label for="color" class="label">Color</label>

              <div class="control">
                <input id="color" name="color" class="input" type="text" value="Custom Value">
              </div>
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with errors: value' do
      let(:errors)  { ['is not red', 'is not blue'] }
      let(:options) { super().merge(errors: errors) }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label for="color" class="label">Color</label>

            <div class="control has-icons-right">
              <input id="color" name="color" class="input is-danger" type="text">

              <span class="icon is-right is-small">
                <i class="fas fa-triangle-exclamation"></i>
              </span>
            </div>

            <p class="help is-danger">is not red, is not blue</p>
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
          <div class="field">
            <label for="color" class="label">Color</label>

            <div class="control has-icons-left">
              <input id="color" name="color" class="input" type="text">

              <span class="icon is-left is-small">
                <i class="fas fa-radiation"></i>
              </span>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with label: value' do
      let(:label)   { 'Custom Label' }
      let(:options) { super().merge(label: label) }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label for="color" class="label">Custom Label</label>

            <div class="control">
              <input id="color" name="color" class="input" type="text">
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with name: bracket-separated string' do
      let(:name) { 'image[color]' }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label for="image_color" class="label">Color</label>

            <div class="control">
              <input id="image_color" name="image[color]" class="input" type="text">
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with data: value' do
        let(:data)    { { 'image' => { 'color' => 'polka dots' } } }
        let(:options) { super().merge(data: data) }
        let(:snapshot) do
          <<~HTML
            <div class="field">
              <label for="image_color" class="label">Color</label>

              <div class="control">
                <input id="image_color" name="image[color]" class="input" type="text" value="polka dots">
              </div>
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }

        describe 'with value: value' do
          let(:value)   { 'Custom Value' }
          let(:options) { super().merge(value: value) }
          let(:snapshot) do
            <<~HTML
              <div class="field">
                <label for="image_color" class="label">Color</label>

                <div class="control">
                  <input id="image_color" name="image[color]" class="input" type="text" value="Custom Value">
                </div>
              </div>
            HTML
          end

          it { expect(rendered).to match_snapshot(snapshot) }
        end
      end
    end

    describe 'with name: period-separated string' do
      let(:name) { 'image.color' }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label for="image_color" class="label">Color</label>

            <div class="control">
              <input id="image_color" name="image.color" class="input" type="text">
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with data: value' do
        let(:data)    { { 'image' => { 'color' => 'polka dots' } } }
        let(:options) { super().merge(data: data) }
        let(:snapshot) do
          <<~HTML
            <div class="field">
              <label for="image_color" class="label">Color</label>

              <div class="control">
                <input id="image_color" name="image.color" class="input" type="text" value="polka dots">
              </div>
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }

        describe 'with value: value' do
          let(:value)   { 'Custom Value' }
          let(:options) { super().merge(value: value) }
          let(:snapshot) do
            <<~HTML
              <div class="field">
                <label for="image_color" class="label">Color</label>

                <div class="control">
                  <input id="image_color" name="image.color" class="input" type="text" value="Custom Value">
                </div>
              </div>
            HTML
          end

          it { expect(rendered).to match_snapshot(snapshot) }
        end
      end
    end

    describe 'with placeholder: value' do
      let(:placeholder) { 'Custom Placeholder' }
      let(:options)     { super().merge(placeholder: placeholder) }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label for="color" class="label">Color</label>

            <div class="control">
              <input id="color" name="color" class="input" placeholder="Custom Placeholder" type="text">
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with type: value' do
      let(:type)    { 'email' }
      let(:options) { super().merge(type: type) }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label for="color" class="label">Color</label>

            <div class="control">
              <input id="color" name="color" class="input" type="email">
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with value: value' do
      let(:value) { 'Custom Value' }
      let(:options) { super().merge(value: value) }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label for="color" class="label">Color</label>

            <div class="control">
              <input id="color" name="color" class="input" type="text" value="Custom Value">
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#data' do
    include_examples 'should define reader', :data, nil

    context 'when initialized with data: value' do
      let(:rocket)  { Spec::Rocket.new(name: 'Imp IV', color: 'red') }
      let(:data)    { { 'rocket' => rocket } }
      let(:options) { super().merge(data: data) }

      it { expect(field.data).to be == data }
    end
  end

  describe '#errors' do
    include_examples 'should define reader', :errors, nil

    context 'when initialized with errors: value' do
      let(:errors)  { ["can't be blank"] }
      let(:options) { super().merge(errors: errors) }

      it { expect(field.errors).to be == errors }
    end
  end

  describe '#icon' do
    include_examples 'should define reader', :icon, nil

    context 'when initialized with icon: value' do
      let(:icon)    { 'radiation' }
      let(:options) { super().merge(icon: icon) }

      it { expect(field.icon).to be == icon }
    end
  end

  describe '#label' do
    let(:expected) { name.titleize }

    include_examples 'should define reader', :label, -> { expected }

    context 'when initialized with label: value' do
      let(:label)   { 'Custom Label' }
      let(:options) { super().merge(label: label) }

      it { expect(field.label).to be == label }
    end

    context 'when initialized with name: bracket-separated string' do
      let(:name)     { 'image[color]' }
      let(:expected) { 'Color' }

      it { expect(field.label).to be == expected }
    end

    describe 'with name: period-separated string' do
      let(:name) { 'image.color' }
      let(:expected) { 'Color' }

      it { expect(field.label).to be == expected }
    end
  end

  describe '#name' do
    include_examples 'should define reader', :name, -> { name }
  end

  describe '#placeholder' do
    include_examples 'should define reader', :placeholder, nil

    context 'when initialized with placeholder: value' do
      let(:placeholder) { 'Enter Username' }
      let(:options)     { super().merge(placeholder: placeholder) }

      it { expect(field.placeholder).to be == placeholder }
    end
  end

  describe '#type' do
    include_examples 'should define reader', :type, 'text'

    context 'when initialized with type: value' do
      let(:type)    { 'email' }
      let(:options) { super().merge(type: type) }

      it { expect(field.type).to be == type }
    end
  end

  describe '#value' do
    include_examples 'should define reader', :value, nil

    context 'when initialized with data: a non-matching Hash' do
      let(:data)    { { 'name' => 'Imp IV' } }
      let(:options) { super().merge(data: data) }

      it { expect(field.value).to be nil }

      context 'when initialized with value: a value' do
        let(:value)   { 'Custom Value' }
        let(:options) { super().merge(value: value) }

        it { expect(field.value).to be == value }
      end
    end

    context 'when initialized with data: a non-matching Object' do
      let(:rocket)  { Spec::Rocket.new(name: 'Imp IV') }
      let(:data)    { { 'name' => 'Imp IV' } }
      let(:options) { super().merge(data: data) }

      it { expect(field.value).to be nil }

      context 'when initialized with value: a value' do
        let(:value)   { 'Custom Value' }
        let(:options) { super().merge(value: value) }

        it { expect(field.value).to be == value }
      end
    end

    context 'when initialized with data: a matching Hash' do
      let(:data)    { { 'color' => 'red' } }
      let(:options) { super().merge(data: data) }

      it { expect(field.value).to be == 'red' }

      context 'when initialized with value: a value' do
        let(:value)   { 'Custom Value' }
        let(:options) { super().merge(value: value) }

        it { expect(field.value).to be == value }
      end
    end

    context 'when initialized with data: a matching Object' do
      let(:rocket)  { Spec::Rocket.new(name: 'Imp IV', color: 'red') }
      let(:data)    { rocket }
      let(:options) { super().merge(data: data) }

      it { expect(field.value).to be == 'red' }

      context 'when initialized with value: a value' do
        let(:value)   { 'Custom Value' }
        let(:options) { super().merge(value: value) }

        it { expect(field.value).to be == value }
      end
    end

    context 'when initialized with name: a bracket-scoped String' do
      let(:name) { 'rocket[color]' }

      context 'when initialized with non-matching data' do
        let(:rocket)  { Spec::Rocket.new(name: 'Imp IV') }
        let(:data)    { { 'rocket' => rocket } }
        let(:options) { super().merge(data: data) }

        it { expect(field.value).to be nil }

        context 'when initialized with value: a value' do
          let(:value)   { 'Custom Value' }
          let(:options) { super().merge(value: value) }

          it { expect(field.value).to be == value }
        end
      end

      context 'when initialized with matching data' do
        let(:rocket)  { Spec::Rocket.new(name: 'Imp IV', color: 'red') }
        let(:data)    { { 'rocket' => rocket } }
        let(:options) { super().merge(data: data) }

        it { expect(field.value).to be == 'red' }

        context 'when initialized with value: a value' do
          let(:value)   { 'Custom Value' }
          let(:options) { super().merge(value: value) }

          it { expect(field.value).to be == value }
        end
      end
    end

    context 'when initialized with name: a period-scoped String' do
      let(:name) { 'rocket.color' }

      context 'when initialized with non-matching data' do
        let(:rocket)  { Spec::Rocket.new(name: 'Imp IV') }
        let(:data)    { { 'rocket' => rocket } }
        let(:options) { super().merge(data: data) }

        it { expect(field.value).to be nil }

        context 'when initialized with value: a value' do
          let(:value)   { 'Custom Value' }
          let(:options) { super().merge(value: value) }

          it { expect(field.value).to be == value }
        end
      end

      context 'when initialized with matching data' do
        let(:rocket)  { Spec::Rocket.new(name: 'Imp IV', color: 'red') }
        let(:data)    { { 'rocket' => rocket } }
        let(:options) { super().merge(data: data) }

        it { expect(field.value).to be == 'red' }

        context 'when initialized with value: a value' do
          let(:value)   { 'Custom Value' }
          let(:options) { super().merge(value: value) }

          it { expect(field.value).to be == value }
        end
      end
    end

    context 'when initialized with value: a value' do
      let(:value)   { 'Custom Value' }
      let(:options) { super().merge(value: value) }

      it { expect(field.value).to be == value }
    end
  end
end
