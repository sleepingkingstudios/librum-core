# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::IconText, type: :component do
  include Librum::Core::RSpec::Contracts::ComponentContracts

  subject(:component) { described_class.new(**options) }

  let(:contents) { nil }
  let(:icon)     { nil }
  let(:options)  { { contents: contents, icon: icon } }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:class_name, :color, :contents, :icon)
        .and_any_keywords
    end
  end

  include_contract 'should define options'

  include_contract 'should define option', :color

  include_contract 'should define class name option'

  describe '#call' do
    let(:rendered) { render_inline(component) }

    it { expect(rendered.to_s).to be == '' }

    describe 'with contents: nil' do
      let(:contents) { nil }

      it { expect(rendered.to_s).to be == '' }
    end

    describe 'with contents: an empty String' do
      let(:contents) { '' }

      it { expect(rendered.to_s).to be == '' }
    end

    describe 'with contents: a Component' do
      let(:contents) do
        Librum::Core::View::Components::MockComponent.new('component')
      end
      let(:snapshot) do
        <<~HTML
          <span class="icon-text">
            <mock name="component"></mock>
          </span>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with class_name: value' do
        let(:options) { super().merge(class_name: 'is-uppercase') }
        let(:snapshot) do
          <<~HTML
            <span class="icon-text is-uppercase">
              <mock name="component"></mock>
            </span>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with color: value' do
        let(:options) { super().merge(color: 'warning') }
        let(:snapshot) do
          <<~HTML
            <span class="icon-text has-text-warning">
              <mock name="component"></mock>
            </span>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with icon: value' do
        let(:icon)    { 'radiation' }
        let(:options) { super().merge(icon: icon) }
        let(:snapshot) do
          <<~HTML
            <span class="icon-text">
              <span class="icon">
                <i class="fas fa-radiation"></i>
              </span>

              <mock name="component"></mock>
            </span>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with contents: a String' do
      let(:contents) { 'Reactor temperature critical' }
      let(:snapshot) do
        <<~HTML
          <span class="icon-text">
            <span>Reactor temperature critical</span>
          </span>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with class_name: value' do
        let(:options) { super().merge(class_name: 'is-uppercase') }
        let(:snapshot) do
          <<~HTML
            <span class="icon-text is-uppercase">
              <span>Reactor temperature critical</span>
            </span>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with color: value' do
        let(:options) { super().merge(color: 'warning') }
        let(:snapshot) do
          <<~HTML
            <span class="icon-text has-text-warning">
              <span>Reactor temperature critical</span>
            </span>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with icon: value' do
        let(:icon)    { 'radiation' }
        let(:options) { super().merge(icon: icon) }
        let(:snapshot) do
          <<~HTML
            <span class="icon-text">
              <span class="icon">
                <i class="fas fa-radiation"></i>
              </span>

              <span>Reactor temperature critical</span>
            </span>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with icon: nil' do
      let(:icon) { nil }

      it { expect(rendered.to_s).to be == '' }
    end

    describe 'with icon: an empty String' do
      let(:icon) { '' }

      it { expect(rendered.to_s).to be == '' }
    end

    describe 'with icon: a value' do
      let(:icon) { 'radiation' }
      let(:snapshot) do
        <<~HTML
          <span class="icon-text">
            <span class="icon">
              <i class="fas fa-radiation"></i>
            </span>
          </span>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with class_name: value' do
        let(:options) { super().merge(class_name: 'is-uppercase') }
        let(:snapshot) do
          <<~HTML
            <span class="icon-text is-uppercase">
              <span class="icon">
                <i class="fas fa-radiation"></i>
              </span>
            </span>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with color: value' do
        let(:options) { super().merge(color: 'warning') }
        let(:snapshot) do
          <<~HTML
            <span class="icon-text has-text-warning">
              <span class="icon">
                <i class="fas fa-radiation"></i>
              </span>
            </span>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end
  end

  describe '#contents' do
    include_examples 'should define reader', :contents, nil

    context 'when initialized with contents: a Component' do
      let(:contents) do
        Librum::Core::View::Components::MockComponent.new('component')
      end

      it { expect(component.contents).to be == contents }
    end

    context 'when initialized with contents: a String' do
      let(:contents) { 'Reactor temperature critical' }

      it { expect(component.contents).to be == contents }
    end
  end

  describe '#icon' do
    include_examples 'should define reader', :icon, nil

    context 'when initialized with icon: value' do
      let(:icon) { 'radiation' }

      it { expect(component.icon).to be == icon }
    end
  end
end
