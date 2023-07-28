# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::Link, type: :component do
  subject(:link) { described_class.new(url, **options) }

  let(:url)     { 'path/to/resource' }
  let(:options) { {} }

  describe '.new' do
    let(:expected_keywords) do
      %i[
        button
        class_names
        color
        label
        light
        icon
        outline
      ]
    end

    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(1).argument
        .and_keywords(*expected_keywords)
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(link) }
    let(:snapshot) do
      <<~HTML
        <a class="has-text-link" href="path/to/resource" target="_self">
          path/to/resource
        </a>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with an absolute url' do
      let(:url) { '/path/to/resource' }
      let(:snapshot) do
        <<~HTML
          <a class="has-text-link" href="/path/to/resource" target="_self">
            /path/to/resource
          </a>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with an external url' do
      let(:url) { 'www.example.com' }
      let(:snapshot) do
        <<~HTML
          <a class="has-text-link" href="https://www.example.com" target="_blank">
            www.example.com
          </a>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with an external url with protocol' do
      let(:url) { 'http://www.example.com' }
      let(:snapshot) do
        <<~HTML
          <a class="has-text-link" href="http://www.example.com" target="_blank">
            http://www.example.com
          </a>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with button: true' do
      let(:options) { super().merge(button: true) }
      let(:snapshot) do
        <<~HTML
          <a class="button" href="path/to/resource" target="_self">
            path/to/resource
          </a>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with color: value' do
        let(:options) { super().merge(color: 'danger') }
        let(:snapshot) do
          <<~HTML
            <a class="button is-danger" href="path/to/resource" target="_self">
              path/to/resource
            </a>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with light: true' do
        let(:options) { super().merge(light: true) }
        let(:snapshot) do
          <<~HTML
            <a class="button is-light" href="path/to/resource" target="_self">
              path/to/resource
            </a>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with outline: true' do
        let(:options) { super().merge(outline: true) }
        let(:snapshot) do
          <<~HTML
            <a class="button is-outlined" href="path/to/resource" target="_self">
              path/to/resource
            </a>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with class_names: value' do
      let(:options) { super().merge(class_names: %w[custom-class]) }
      let(:snapshot) do
        <<~HTML
          <a class="custom-class has-text-link" href="path/to/resource" target="_self">
            path/to/resource
          </a>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with color: value' do
      let(:options) { super().merge(color: 'danger') }
      let(:snapshot) do
        <<~HTML
          <a class="has-text-danger" href="path/to/resource" target="_self">
            path/to/resource
          </a>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with icon: value' do
      let(:icon)    { 'radiation' }
      let(:options) { super().merge(icon: icon) }
      let(:snapshot) do
        <<~HTML
          <a class="has-text-link" href="path/to/resource" target="_self">
            <span class="icon-text">
              <span class="icon">
                <i class="fas fa-radiation"></i>
              </span>

              <span>path/to/resource</span>
            </span>
          </a>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with label: value' do
      let(:label)   { 'Resource Name' }
      let(:options) { super().merge(label: label) }
      let(:snapshot) do
        <<~HTML
          <a class="has-text-link" href="path/to/resource" target="_self">
            Resource Name
          </a>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#button?' do
    include_examples 'should define predicate', :button?, false

    context 'when initialized with button: true' do
      let(:options) { super().merge(button: true) }

      it { expect(link.button?).to be true }
    end
  end

  describe '#class_names' do
    include_examples 'should define reader', :class_names, 'has-text-link'

    context 'when initialized with class_names: an Array' do
      let(:class_names) { %w[custom-class other-class] }
      let(:options)     { super().merge(class_names: class_names) }
      let(:expected)    { 'custom-class other-class has-text-link' }

      it { expect(link.class_names).to be == expected }
    end

    context 'when initialized with class_names: a String' do
      let(:class_names) { 'custom-class other-class' }
      let(:options)     { super().merge(class_names: class_names) }
      let(:expected)    { 'custom-class other-class has-text-link' }

      it { expect(link.class_names).to be == expected }
    end
  end

  describe '#color' do
    include_examples 'should define reader', :color, nil

    context 'when initialized with color: value' do
      let(:color)   { 'danger' }
      let(:options) { super().merge(color: color) }

      it { expect(link.color).to be == color }
    end
  end

  describe '#external?' do
    include_examples 'should define predicate', :external?, false

    context 'when initialized with an absolute url' do
      let(:url) { '/path/to/resource' }

      it { expect(link.external?).to be false }
    end

    context 'when initialized with an external url' do
      let(:url) { 'www.example.com' }

      it { expect(link.external?).to be true }
    end

    context 'when initialized with an external url with protocol' do
      let(:url) { 'http://www.example.com' }

      it { expect(link.external?).to be true }
    end
  end

  describe '#icon' do
    include_examples 'should define reader', :icon, nil

    context 'when initialized with icon: value' do
      let(:icon)    { 'radiation' }
      let(:options) { super().merge(icon: icon) }

      it { expect(link.icon).to be == icon }
    end
  end

  describe '#label' do
    include_examples 'should define reader', :label, -> { url }

    context 'when initialized with label: value' do
      let(:label)   { 'Resource Name' }
      let(:options) { super().merge(label: label) }

      it { expect(link.label).to be == label }
    end
  end

  describe '#light?' do
    include_examples 'should define predicate', :light?, false

    context 'when initialized with light: true' do
      let(:options) { super().merge(light: true) }

      it { expect(link.light?).to be true }
    end
  end

  describe '#outline?' do
    include_examples 'should define predicate', :outline?, false

    context 'when initialized with outline: true' do
      let(:options) { super().merge(outline: true) }

      it { expect(link.outline?).to be true }
    end
  end

  describe '#url' do
    include_examples 'should define reader', :url, -> { url }
  end
end
