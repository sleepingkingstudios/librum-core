# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::Link, type: :component do
  include Librum::Core::RSpec::Contracts::ComponentContracts

  subject(:link) { described_class.new(url, **options) }

  let(:url)     { 'path/to/resource' }
  let(:options) { {} }

  describe '.new' do
    let(:expected_keywords) do
      %i[
        button
        class_name
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

  include_contract 'should define options'

  include_contract 'should define option', :button?, boolean: true

  include_contract 'should define option', :color

  include_contract 'should define option', :icon

  include_contract 'should define option', :light?, boolean: true

  include_contract 'should define option', :outline?, boolean: true

  include_contract 'should define class name option'

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

    describe 'with class_name: value' do
      let(:options) { super().merge(class_name: %w[custom-class]) }
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

  describe '#label' do
    include_examples 'should define reader', :label, -> { url }

    context 'when initialized with label: value' do
      let(:label)   { 'Resource Name' }
      let(:options) { super().merge(label: label) }

      it { expect(link.label).to be == label }
    end
  end

  describe '#url' do
    include_examples 'should define reader', :url, -> { url }
  end
end
