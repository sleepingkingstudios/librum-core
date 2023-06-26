# frozen_string_literal: true

require 'rails_helper'

require 'librum/core/view/layouts/page/navigation/menu'

RSpec.describe Librum::Core::View::Layouts::Page::Navigation::Menu,
  type: :component \
do
  subject(:menu) { described_class.new(items: items) }

  let(:dropdown_items) do
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

    ary.map do |item|
      Librum::Core::View::Layouts::Page::Navigation::ItemDefinition.new(**item)
    end
  end
  let(:items) do
    ary = [
      {
        label: 'Rockets',
        url:   '/rockets'
      },
      {
        label: 'Launch Sites',
        url:   '/launch-sites',
        items: dropdown_items
      },
      {
        align: :right,
        label: 'Launch',
        url:   '/launch'
      }
    ]

    ary.map do |item|
      Librum::Core::View::Layouts::Page::Navigation::ItemDefinition.new(**item)
    end
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:items)
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(menu) }
    let(:snapshot) do
      <<~HTML
        <div class="navbar-menu">
          <div class="navbar-start">
            <a class="navbar-item has-text-black" href="/rockets" target="_self">
              Rockets
            </a>

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
          </div>

          <div class="navbar-end">
            <a class="navbar-item has-text-black" href="/launch" target="_self">
              Launch
            </a>
          </div>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }
  end

  describe '#items' do
    include_examples 'should define reader', :items, -> { items }
  end
end
