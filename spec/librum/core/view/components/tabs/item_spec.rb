# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::Tabs::Item, type: :component do
  include Librum::Core::RSpec::Contracts::ComponentContracts

  subject(:tab_item) { described_class.new(tab: tab, **constructor_options) }

  let(:options) { {} }
  let(:tab) do
    Librum::Core::View::Components::Tabs::TabDefinition.new(
      key: 'rockets',
      **options
    )
  end
  let(:constructor_options) { {} }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:active, :tab)
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(tab_item) }
    let(:snapshot) do
      <<~HTML
        <li>
          <a>Rockets</a>
        </li>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with active: true' do
      let(:constructor_options) { super().merge(active: true) }
      let(:snapshot) do
        <<~HTML
          <li class="is-active">
            <a>Rockets</a>
          </li>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with tab: { class_name: value }' do
      let(:options) { super().merge(class_name: 'is-blinking') }
      let(:snapshot) do
        <<~HTML
          <li>
            <a class="is-blinking">Rockets</a>
          </li>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'and tab: { color: value }' do
        let(:options) { super().merge(color: 'danger') }
        let(:snapshot) do
          <<~HTML
            <li>
              <a class="is-blinking has-text-danger">Rockets</a>
            </li>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with tab: { color: value }' do
      let(:options) { super().merge(color: 'danger') }
      let(:snapshot) do
        <<~HTML
          <li>
            <a class="has-text-danger">Rockets</a>
          </li>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with tab: { icon: value }' do
      let(:options) { super().merge(icon: 'radiation') }
      let(:snapshot) do
        <<~HTML
          <li>
            <a>
              <span class="icon-text">
                <span class="icon">
                  <i class="fas fa-radiation"></i>
                </span>

                <span>Rockets</span>
              </span>
            </a>
          </li>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with tab: { label: value }' do
      let(:options) { super().merge(label: 'Rocket Launch Sites') }
      let(:snapshot) do
        <<~HTML
          <li>
            <a>Rocket Launch Sites</a>
          </li>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with tab: { url: value }' do
      let(:options) { super().merge(url: '/path/to/rockets') }
      let(:snapshot) do
        <<~HTML
          <li>
            <a class="has-text-link" href="/path/to/rockets" target="_self">
              Rockets
            </a>
          </li>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with active: true' do
        let(:constructor_options) { super().merge(active: true) }
        let(:snapshot) do
          <<~HTML
            <li class="is-active">
              <a class="has-text-link" href="/path/to/rockets" target="_self">
                Rockets
              </a>
            </li>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with tab: { class_name: value }' do
        let(:options) { super().merge(class_name: 'is-blinking') }
        let(:snapshot) do
          <<~HTML
            <li>
              <a class="is-blinking has-text-link" href="/path/to/rockets" target="_self">
                Rockets
              </a>
            </li>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }

        describe 'and tab: { color: value }' do
          let(:options) { super().merge(color: 'danger') }
          let(:snapshot) do
            <<~HTML
              <li>
                <a class="is-blinking has-text-danger" href="/path/to/rockets" target="_self">
                  Rockets
                </a>
              </li>
            HTML
          end

          it { expect(rendered).to match_snapshot(snapshot) }
        end
      end

      describe 'with tab: { color: value }' do
        let(:options) { super().merge(color: 'danger') }
        let(:snapshot) do
          <<~HTML
            <li>
              <a class="has-text-danger" href="/path/to/rockets" target="_self">
                Rockets
              </a>
            </li>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with tab: { icon: value }' do
        let(:options) { super().merge(icon: 'radiation') }
        let(:snapshot) do
          <<~HTML
            <li>
              <a class="has-text-link" href="/path/to/rockets" target="_self">
                <span class="icon-text">
                  <span class="icon">
                    <i class="fas fa-radiation"></i>
                  </span>

                  <span>Rockets</span>
                </span>
              </a>
            </li>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with tab: { label: value }' do
        let(:options) { super().merge(label: 'Rocket Launch Sites') }
        let(:snapshot) do
          <<~HTML
            <li>
              <a class="has-text-link" href="/path/to/rockets" target="_self">
                Rocket Launch Sites
              </a>
            </li>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end
  end

  describe '#tab' do
    include_examples 'should define reader', :tab, -> { tab }
  end
end
