# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Layouts::Page::Alerts, type: :component do
  subject(:alerts) { described_class.new(alerts: data) }

  let(:data) do
    {
      danger: {
        icon:    'radiation',
        message: 'Reactor temperature critical'
      },
      info:   'Initializing activation sequence'
    }
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:alerts)
        .and_any_keywords
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(alerts) }
    let(:snapshot) do
      <<~HTML
        <div class="notification is-danger">
          <span class="icon-text">
            <span class="icon">
              <i class="fas fa-radiation"></i>
            </span>

            <span>Reactor temperature critical</span>
          </span>
        </div>

        <div class="notification is-info">
          Initializing activation sequence
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }
  end
end
