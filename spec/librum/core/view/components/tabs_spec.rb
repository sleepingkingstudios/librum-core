# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::Tabs, type: :component do
  include Librum::Core::RSpec::Contracts::ComponentContracts

  subject(:tabs) { described_class.new(tabs: tab_items, **constructor_options) }

  shared_context 'with a default tab item' do
    let(:tab_items) do
      super() << {
        key:     'everything',
        label:   'All Launch Sites',
        default: true
      }
    end
  end

  let(:tab_items) do
    [
      {
        key: 'rockets',
        url: '/path/to/rockets'
      },
      {
        key:  'planes',
        icon: 'plane'
      },
      {
        key:   'boats',
        label: 'Watercraft',
        color: 'link-dark'
      }
    ]
  end
  let(:constructor_options) { {} }

  describe '::TabDefinition' do
    subject(:tab) { described_class.new(key: key, **options) }

    let(:described_class) { super()::TabDefinition }
    let(:key)             { 'rockets' }
    let(:options)         { {} }

    describe '.new' do
      let(:expected_keywords) do
        %i[
          icon
          key
          label
          url
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

    include_contract 'should define option', :default, boolean: true

    include_contract 'should define option', :icon

    include_contract 'should define option',
      :label,
      default: -> { key.titleize }

    include_contract 'should define option', :url

    describe '#icon?' do
      include_examples 'should define predicate', :icon?, false

      context 'when initialized with options: { icon: value }' do
        let(:options) { super().merge(icon: 'radiation') }

        it { expect(tab.icon?).to be true }
      end
    end

    describe '#key' do
      include_examples 'should define reader', :key, -> { key }
    end

    describe '#link?' do
      include_examples 'should define predicate', :link?, false

      context 'when initialized with options: { url: value }' do
        let(:options) { super().merge(url: '/path/to/rockets') }

        it { expect(tab.link?).to be true }
      end
    end
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:active, :tabs)
    end
  end

  describe '#active' do
    include_examples 'should define reader', :active, nil

    context 'when initialized with active: value' do
      let(:constructor_options) { super().merge(active: 'planes') }

      it { expect(tabs.active).to be == 'planes' }
    end

    wrap_context 'with a default tab item' do
      it { expect(tabs.active).to be == 'everything' }

      context 'when initialized with active: value' do
        let(:constructor_options) { super().merge(active: 'planes') }

        it { expect(tabs.active).to be == 'planes' }
      end
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(tabs) }
    let(:snapshot) do
      <<~HTML
        <div class="tabs">
          <ul>
            <li>
              <a class="has-text-link" href="/path/to/rockets" target="_self">
                Rockets
              </a>
            </li>

            <li>
              <a>
                <span class="icon-text">
                  <span class="icon">
                    <i class="fas fa-plane"></i>
                  </span>

                  <span>Planes</span>
                </span>
              </a>
            </li>

            <li>
              <a class="has-text-link-dark">Watercraft</a>
            </li>
          </ul>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with active: non-matching value' do
      let(:constructor_options) { super().merge(active: 'rovers') }

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with active: matching value' do
      let(:constructor_options) { super().merge(active: 'rockets') }
      let(:snapshot) do
        <<~HTML
          <div class="tabs">
            <ul>
              <li class="is-active">
                <a class="has-text-link" href="/path/to/rockets" target="_self">
                  Rockets
                </a>
              </li>

              <li>
                <a>
                  <span class="icon-text">
                    <span class="icon">
                      <i class="fas fa-plane"></i>
                    </span>

                    <span>Planes</span>
                  </span>
                </a>
              </li>

              <li>
                <a class="has-text-link-dark">Watercraft</a>
              </li>
            </ul>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    wrap_context 'with a default tab item' do
      let(:snapshot) do
        <<~HTML
          <div class="tabs">
            <ul>
              <li>
                <a class="has-text-link" href="/path/to/rockets" target="_self">
                  Rockets
                </a>
              </li>

              <li>
                <a>
                  <span class="icon-text">
                    <span class="icon">
                      <i class="fas fa-plane"></i>
                    </span>

                    <span>Planes</span>
                  </span>
                </a>
              </li>

              <li>
                <a class="has-text-link-dark">Watercraft</a>
              </li>

              <li class="is-active">
                <a>All Launch Sites</a>
              </li>
            </ul>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with active: non-matching value' do
        let(:constructor_options) { super().merge(active: 'rovers') }
        let(:snapshot) do
          <<~HTML
            <div class="tabs">
              <ul>
                <li>
                  <a class="has-text-link" href="/path/to/rockets" target="_self">
                    Rockets
                  </a>
                </li>

                <li>
                  <a>
                    <span class="icon-text">
                      <span class="icon">
                        <i class="fas fa-plane"></i>
                      </span>

                      <span>Planes</span>
                    </span>
                  </a>
                </li>

                <li>
                  <a class="has-text-link-dark">Watercraft</a>
                </li>

                <li>
                  <a>All Launch Sites</a>
                </li>
              </ul>
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with active: matching value' do
        let(:constructor_options) { super().merge(active: 'rockets') }
        let(:snapshot) do
          <<~HTML
            <div class="tabs">
              <ul>
                <li class="is-active">
                  <a class="has-text-link" href="/path/to/rockets" target="_self">
                    Rockets
                  </a>
                </li>

                <li>
                  <a>
                    <span class="icon-text">
                      <span class="icon">
                        <i class="fas fa-plane"></i>
                      </span>

                      <span>Planes</span>
                    </span>
                  </a>
                </li>

                <li>
                  <a class="has-text-link-dark">Watercraft</a>
                </li>

                <li>
                  <a>All Launch Sites</a>
                </li>
              </ul>
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end
  end

  describe '#tabs' do
    let(:tab_class) do
      Librum::Core::View::Components::Tabs::TabDefinition
    end
    let(:expected_default) do
      tab_items.map { |item| !!item[:default] } # rubocop:disable Style/DoubleNegation
    end
    let(:expected_labels) do
      tab_items.map { |item| item.fetch(:label) { item[:key].to_s.titleize } }
    end

    include_examples 'should define reader',
      :tabs,
      -> { an_instance_of(Array) }

    it { expect(tabs.tabs).to all be_a tab_class }

    it { expect(tabs.tabs.map(&:color)).to be == tab_items.pluck(:color) }

    it { expect(tabs.tabs.map(&:default?)).to be == expected_default }

    it { expect(tabs.tabs.map(&:key)).to be == tab_items.pluck(:key) }

    it { expect(tabs.tabs.map(&:icon)).to be == tab_items.pluck(:icon) }

    it { expect(tabs.tabs.map(&:label)).to be == expected_labels }

    it { expect(tabs.tabs.map(&:url)).to be == tab_items.pluck(:url) }

    context 'when initialized with tab definitions' do
      let(:tab_items) { super().map { |hsh| tab_class.new(**hsh) } }

      it { expect(tabs.tabs).to be == tab_items }
    end

    wrap_context 'with a default tab item' do
      it { expect(tabs.tabs.map(&:color)).to be == tab_items.pluck(:color) }

      it { expect(tabs.tabs.map(&:default?)).to be == expected_default }

      it { expect(tabs.tabs.map(&:key)).to be == tab_items.pluck(:key) }

      it { expect(tabs.tabs.map(&:icon)).to be == tab_items.pluck(:icon) }

      it { expect(tabs.tabs.map(&:label)).to be == expected_labels }

      it { expect(tabs.tabs.map(&:url)).to be == tab_items.pluck(:url) }

      context 'when initialized with tab definitions' do
        let(:tab_items) { super().map { |hsh| tab_class.new(**hsh) } }

        it { expect(tabs.tabs).to be == tab_items }
      end
    end
  end
end
