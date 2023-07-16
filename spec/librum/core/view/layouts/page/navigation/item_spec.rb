# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Layouts::Page::Navigation::Item,
  type: :component \
do
  subject(:nav_item) { described_class.new(item: item) }

  shared_context 'when initialized with an item with dropdown items' do
    let(:item) do
      ary = [
        {
          label: 'Rockets',
          url:   '/launch_sites/rockets'
        },
        {
          label: 'Planes',
          url:   '/launch_sites/planes'
        },
        {
          label: 'Zeppelins',
          url:   '/launch_sites/zeppelins'
        }
      ]
      items = ary.map do |item|
        Librum::Core::View::Layouts::Page::Navigation::ItemDefinition
          .new(**item)
      end

      Librum::Core::View::Layouts::Page::Navigation::ItemDefinition.new(
        label: 'Launch Sites',
        url:   '/launch-sites',
        items: items
      )
    end
  end

  let(:item) do
    Librum::Core::View::Layouts::Page::Navigation::ItemDefinition.new(
      label: 'Rockets',
      url:   '/rockets'
    )
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:item)
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(nav_item) }
    let(:snapshot) do
      <<~HTML
        <a class="navbar-item has-text-black" href="/rockets" target="_self">
          Rockets
        </a>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with an item with dropdown items' do
      include_context 'when initialized with an item with dropdown items'

      let(:snapshot) do
        <<~HTML
          <div class="navbar-item has-dropdown is-hoverable">
            <a class="navbar-link">
              Launch Sites
            </a>

            <div class="navbar-dropdown">
              <a class="navbar-item has-text-black" href="/launch_sites/rockets" target="_self">
                Rockets
              </a>

              <a class="navbar-item has-text-black" href="/launch_sites/planes" target="_self">
                Planes
              </a>

              <a class="navbar-item has-text-black" href="/launch_sites/zeppelins" target="_self">
                Zeppelins
              </a>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#item' do
    include_examples 'should define reader', :item, -> { item }
  end

  describe '#items' do
    include_examples 'should define reader', :items, []

    wrap_context 'when initialized with an item with dropdown items' do
      it { expect(nav_item.items).to be == item.items }
    end
  end

  describe '#label' do
    include_examples 'should define reader', :label, -> { item.label }
  end

  describe '#url' do
    include_examples 'should define reader', :url, -> { item.url }
  end
end
