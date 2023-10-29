# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::Alert, type: :component do
  include Librum::Core::RSpec::Contracts::ComponentContracts

  subject(:component) { described_class.new(message, **options) }

  let(:message)  { 'Reactor temperature critical' }
  let(:options)  { {} }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(1).argument
        .and_keywords(:color, :dismissable, :icon)
        .and_any_keywords
    end
  end

  include_contract 'should define options'

  include_contract 'should define option', :color, default: 'info'

  include_contract 'should define option',
    :dismissable,
    boolean: true,
    default: true

  include_contract 'should define option', :icon

  describe '#call' do
    let(:rendered) { render_inline(component) }
    let(:snapshot) do
      <<~HTML
        <div class="alert notification is-info" data-controller="dismissable">
          <button data-action="click-&gt;dismissable#close" class="delete is-medium"></button>

          Reactor temperature critical
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with color: value' do
      let(:options) { super().merge(color: 'danger') }
      let(:snapshot) do
        <<~HTML
          <div class="alert notification is-danger" data-controller="dismissable">
            <button data-action="click-&gt;dismissable#close" class="delete is-medium"></button>

            Reactor temperature critical
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with dismissable: false' do
      let(:options) { super().merge(dismissable: false) }
      let(:snapshot) do
        <<~HTML
          <div class="alert notification is-info">
            Reactor temperature critical
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with icon: value' do
      let(:options) { super().merge(icon: 'radiation') }
      let(:snapshot) do
        <<~HTML
          <div class="alert notification is-info" data-controller="dismissable">
            <button data-action="click-&gt;dismissable#close" class="delete is-medium"></button>

            <span class="icon-text">
              <span class="icon">
                <i class="fas fa-radiation"></i>
              </span>

              <span>Reactor temperature critical</span>
            </span>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end
end
