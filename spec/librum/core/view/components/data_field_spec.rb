# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::DataField, type: :component do
  include Librum::Core::RSpec::Contracts::ComponentContracts

  subject(:data_field) { described_class.new(**constructor_options) }

  let(:data)                { Struct.new(:name).new('Alan Bradley') }
  let(:field)               { { key: 'name', **options } }
  let(:options)             { {} }
  let(:constructor_options) { { data: data, field: field } }

  describe '::FieldDefinition' do
    subject(:field) { described_class.new(key: key, **options) }

    let(:described_class) { super()::FieldDefinition }
    let(:key)             { 'name' }
    let(:options)         { {} }

    describe '.new' do
      let(:expected_keywords) do
        %i[
          class_name
          color
          default
          icon
          key
          label
          type
          value
        ]
      end

      it 'should define the constructor' do
        expect(described_class)
          .to be_constructible
          .with(0).arguments
          .and_keywords(*expected_keywords)
          .and_any_keywords
      end
    end

    include_contract 'should define options'

    include_contract 'should define option', :color

    include_contract 'should define option', :default

    include_contract 'should define option', :icon

    include_contract 'should define option',
      :label,
      default: -> { key.titleize }

    include_contract 'should define class name option'

    describe '#key' do
      include_examples 'should define reader', :key, -> { key }
    end

    describe '#type' do
      include_examples 'should define reader', :type, :text

      context 'when initialized with type: value' do
        let(:type)    { :link }
        let(:options) { super().merge(type: type) }

        it { expect(field.type).to be :link }
      end
    end

    describe '#value' do
      include_examples 'should define reader', :value, nil

      context 'when initialized with value: a Proc' do
        let(:value)   { ->(item) { "#{item.first_name} #{item.last_name}" } }
        let(:options) { super().merge(value: value) }

        it { expect(field.value).to be value }
      end

      context 'when initialized with value: a ViewComponent' do
        let(:value)   { Spec::CustomComponent.new }
        let(:options) { super().merge(value: value) }

        example_class 'Spec::CustomComponent', ViewComponent::Base

        it { expect(field.value).to be value }
      end
    end
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:data, :field)
        .and_any_keywords
    end
  end

  include_contract 'should define options'

  include_contract 'should define option', :color

  include_contract 'should define option', :default

  include_contract 'should define option', :icon

  include_contract 'should define option',
    :label,
    default: -> { key.titleize }

  include_contract 'should define class name option'

  describe '#call' do
    let(:rendered) { render_inline(data_field) }
    let(:snapshot) do
      <<~HTML
        Alan Bradley
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with field: { class_name: value }' do
      let(:options) { super().merge(class_name: 'is-uppercase') }
      let(:snapshot) do
        <<~HTML
          <span class="is-uppercase">Alan Bradley</span>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with field: { color: value }' do
      let(:options) { super().merge(color: 'danger') }
      let(:snapshot) do
        <<~HTML
          <span class="has-text-danger">Alan Bradley</span>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with field: { default: a value }' do
      let(:options) { super().merge(default: '(none)') }

      context 'when the value is nil' do
        let(:data) { Struct.new(:name).new(nil) }
        let(:snapshot) do
          <<~HTML
            (none)
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      context 'when the value is an empty string' do
        let(:data) { Struct.new(:name).new('') }
        let(:snapshot) do
          <<~HTML
            (none)
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      context 'when the value is present' do
        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with field: { default: a Proc }' do
      let(:options) do
        super().merge(default: ->(item) { item.name.underscore.tr('_ ', '--') })
      end
      let(:field) { { key: 'slug', **options } }

      context 'when the value is nil' do
        let(:data) { Struct.new(:name, :slug).new('Alan Bradley', nil) }
        let(:snapshot) do
          <<~HTML
            alan-bradley
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      context 'when the value is an empty string' do
        let(:data) { Struct.new(:name, :slug).new('Alan Bradley', '') }
        let(:snapshot) do
          <<~HTML
            alan-bradley
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      context 'when the value is present' do
        let(:data) { Struct.new(:name, :slug).new('Alan Bradley', 'alan-b') }
        let(:snapshot) do
          <<~HTML
            alan-b
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with field: { icon }' do
      let(:options) { super().merge(icon: 'user') }
      let(:snapshot) do
        <<~HTML
          <span class="icon-text">
            <span class="icon">
              <i class="fas fa-user"></i>
            </span>

            <span>Alan Bradley</span>
          </span>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with field: { type: :boolean }' do
      let(:options) { super().merge(type: :boolean) }
      let(:field)   { { key: 'admin', **options } }

      context 'when the field value is false' do
        let(:data) { Struct.new(:name, :admin).new('Alan Bradley', false) }
        let(:snapshot) do
          <<~HTML
            <span class="icon has-text-danger">
              <i class="fas fa-xmark"></i>
            </span>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }

        describe 'with field: { class_name: value }' do
          let(:options) { super().merge(class_name: 'is-animated') }
          let(:snapshot) do
            <<~HTML
              <span class="icon is-animated has-text-danger">
                <i class="fas fa-xmark"></i>
              </span>
            HTML
          end

          it { expect(rendered).to match_snapshot(snapshot) }
        end

        describe 'with field: { color: value }' do
          let(:options) { super().merge(color: 'info') }
          let(:snapshot) do
            <<~HTML
              <span class="icon has-text-info">
                <i class="fas fa-xmark"></i>
              </span>
            HTML
          end

          it { expect(rendered).to match_snapshot(snapshot) }
        end
      end

      context 'when the field value is true' do
        let(:data) { Struct.new(:name, :admin).new('Alan Bradley', true) }
        let(:snapshot) do
          <<~HTML
            <span class="icon has-text-success">
              <i class="fas fa-check"></i>
            </span>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }

        describe 'with field: { class_name: value }' do
          let(:options) { super().merge(class_name: 'is-animated') }
          let(:snapshot) do
            <<~HTML
              <span class="icon is-animated has-text-success">
                <i class="fas fa-check"></i>
              </span>
            HTML
          end

          it { expect(rendered).to match_snapshot(snapshot) }
        end

        describe 'with field: { color: value }' do
          let(:options) { super().merge(color: 'info') }
          let(:snapshot) do
            <<~HTML
              <span class="icon has-text-info">
                <i class="fas fa-check"></i>
              </span>
            HTML
          end

          it { expect(rendered).to match_snapshot(snapshot) }
        end
      end
    end

    describe 'with field: { type: :link }' do
      let(:options) { super().merge(type: :link) }
      let(:field)   { { key: 'url', **options } }
      let(:data)    { Struct.new(:url).new('example.com/users/alan-bradley') }
      let(:snapshot) do
        <<~HTML
          <a class="has-text-link" href="https://example.com/users/alan-bradley" target="_blank">
            example.com/users/alan-bradley
          </a>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with field: { class_name: value }' do
        let(:options) { super().merge(class_name: 'is-uppercase') }
        let(:snapshot) do
          <<~HTML
            <a class="is-uppercase has-text-link" href="https://example.com/users/alan-bradley" target="_blank">
              example.com/users/alan-bradley
            </a>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with field: { color: value }' do
        let(:options) { super().merge(color: 'danger') }
        let(:snapshot) do
          <<~HTML
            <a class="has-text-danger" href="https://example.com/users/alan-bradley" target="_blank">
              example.com/users/alan-bradley
            </a>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with field: { icon }' do
        let(:field) { { key: 'url', type: :link, icon: 'globe' } }
        let(:snapshot) do
          <<~HTML
            <a class="has-text-link" href="https://example.com/users/alan-bradley" target="_blank">
              <span class="icon-text">
                <span class="icon">
                  <i class="fas fa-globe"></i>
                </span>

                <span>example.com/users/alan-bradley</span>
              </span>
            </a>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with field: { value: a Proc }' do
      let(:value) { ->(item) { "#{item.first_name} #{item.last_name}" } }
      let(:field) { { key: 'name', value: value } }
      let(:data) do
        Struct.new(:first_name, :last_name).new('Alan', 'Bradley')
      end
      let(:snapshot) do
        <<~HTML
          Alan Bradley
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with field: { value: a ViewComponent }' do
      let(:value) { Spec::CustomField.new }
      let(:field) { { key: 'name', value: value } }
      let(:snapshot) do
        <<~HTML
          Custom Field
        HTML
      end

      example_class 'Spec::CustomField', ViewComponent::Base do |klass|
        klass.define_method(:call) { 'Custom Field' }
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#data' do
    include_examples 'should define reader', :data, -> { data }
  end

  describe '#field' do
    include_examples 'should define reader', :field

    it { expect(data_field.field).to be_a described_class::FieldDefinition }

    it { expect(data_field.field.key).to be == field[:key] }

    context 'when initialized with field: a FieldDefinition' do
      let(:field) do
        described_class::FieldDefinition.new(**super())
      end

      it { expect(data_field.field).to be == field }
    end
  end

  describe '#key' do
    include_examples 'should define reader', :key, -> { field[:key] }
  end

  describe '#type' do
    include_examples 'should define reader', :type, :text

    context 'when initialized with field: { type: a value }' do
      let(:field) { { key: 'name', type: :link } }

      it { expect(data_field.type).to be == field[:type] }
    end
  end

  describe '#value' do
    include_examples 'should define reader', :value, nil

    context 'when initialized with field: { value: a value }' do
      let(:value) { ->(item) { "#{item.first_name} #{item.last_name}" } }
      let(:field) { { key: 'name', value: value } }

      it { expect(data_field.value).to be == field[:value] }
    end
  end
end
