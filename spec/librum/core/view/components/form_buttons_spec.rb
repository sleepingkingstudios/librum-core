# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::FormButtons, type: :component do
  subject(:buttons) { described_class.new(**options) }

  let(:options) { {} }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:cancel_label, :cancel_url, :submit_label)
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(buttons) }
    let(:snapshot) do
      <<~HTML
        <div class="field mt-5">
          <div class="control">
            <div class="columns">
              <div class="column is-half-tablet is-one-quarter-desktop">
                <button type="submit" class="button is-primary is-fullwidth">Submit</button>
              </div>
            </div>
          </div>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with cancel_url: value' do
      let(:cancel_url) { '/launch' }
      let(:options)    { super().merge(cancel_url: cancel_url) }
      let(:snapshot) do
        <<~HTML
          <div class="field mt-5">
            <div class="control">
              <div class="columns">
                <div class="column is-half-tablet is-one-quarter-desktop">
                  <button type="submit" class="button is-primary is-fullwidth">Submit</button>
                </div>

                <div class="column is-half-tablet is-one-quarter-desktop">
                  <a class="button is-fullwidth has-text-black" href="/launch" target="_self">
                    Cancel
                  </a>
                </div>
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with cancel_label: value' do
        let(:cancel_label) { 'Scrub Launch' }
        let(:options)      { super().merge(cancel_label: cancel_label) }
        let(:snapshot) do
          <<~HTML
            <div class="field mt-5">
              <div class="control">
                <div class="columns">
                  <div class="column is-half-tablet is-one-quarter-desktop">
                    <button type="submit" class="button is-primary is-fullwidth">Submit</button>
                  </div>

                  <div class="column is-half-tablet is-one-quarter-desktop">
                    <a class="button is-fullwidth has-text-black" href="/launch" target="_self">
                      Scrub Launch
                    </a>
                  </div>
                </div>
              </div>
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with submit_label: value' do
      let(:submit_label) { 'Launch Rocket' }
      let(:options)      { super().merge(submit_label: submit_label) }
      let(:snapshot) do
        <<~HTML
          <div class="field mt-5">
            <div class="control">
              <div class="columns">
                <div class="column is-half-tablet is-one-quarter-desktop">
                  <button type="submit" class="button is-primary is-fullwidth">Launch Rocket</button>
                </div>
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#cancel_label' do
    include_examples 'should define reader', :cancel_label, 'Cancel'

    context 'when initialized with cancel_label: value' do
      let(:cancel_label) { 'Scrub Launch' }
      let(:options)      { super().merge(cancel_label: cancel_label) }

      it { expect(buttons.cancel_label).to be == cancel_label }
    end
  end

  describe '#cancel_url' do
    include_examples 'should define reader', :cancel_url, nil

    context 'when initialized with cancel_url: value' do
      let(:cancel_url) { '/launch' }
      let(:options)    { super().merge(cancel_url: cancel_url) }

      it { expect(buttons.cancel_url).to be == cancel_url }
    end
  end

  describe '#submit_label' do
    include_examples 'should define reader', :submit_label, 'Submit'

    context 'when initialized with submit_label: value' do
      let(:submit_label) { 'Launch Rocket' }
      let(:options)      { super().merge(submit_label: submit_label) }

      it { expect(buttons.submit_label).to be == submit_label }
    end
  end
end
