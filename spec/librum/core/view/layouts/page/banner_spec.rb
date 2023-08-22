# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Layouts::Page::Banner, type: :component do
  subject(:banner) { described_class.new(**options) }

  let(:options) { {} }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:navigation, :subtitle, :title)
        .and_any_keywords
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(banner) }

    it { expect(rendered.to_s).to be == '' }

    describe 'with navigation: value' do
      let(:navigation) { { label: 'Sleeping King Studios' } }
      let(:options)    { super().merge(navigation: navigation) }
      let(:snapshot) do
        <<~HTML
          <section class="banner hero is-small">
            <div class="hero-body">
              <div class="container">
                <div>
                  <nav class="navbar is-size-5" role="navigation" aria-label="main-navigation">
                    <div class="navbar-brand">
                      <a class="navbar-item pl-1 has-text-black" href="/" target="_self">
                        Sleeping King Studios
                      </a>

                      <a role="button" class="navbar-burger" aria-label="menu" aria-expanded="false">
                        <span aria-hidden="true"></span>

                        <span aria-hidden="true"></span>

                        <span aria-hidden="true"></span>
                      </a>
                    </div>

                    <div class="navbar-menu">
                      <div class="navbar-start">
                      </div>

                      <div class="navbar-end">
                      </div>
                    </div>
                  </nav>
                </div>

                <hr class="is-fancy-hr">
              </div>
            </div>
          </section>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with title: value' do
      let(:title)   { 'Librum' }
      let(:options) { super().merge(title: title) }
      let(:snapshot) do
        <<~HTML
          <section class="banner hero is-small">
            <div class="hero-body">
              <div class="container">
                <div>
                  <p class="title">
                    Librum
                  </p>
                </div>

                <hr class="is-fancy-hr">
              </div>
            </div>
          </section>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with subtitle: value' do
        let(:subtitle) { 'Tabletop Campaign Companion' }
        let(:options)  { super().merge(subtitle: subtitle) }
        let(:snapshot) do
          <<~HTML
            <section class="banner hero is-small">
              <div class="hero-body">
                <div class="container">
                  <div>
                    <p class="title">
                      Librum

                      <span class="subtitle is-block is-inline-tablet mt-3">Tabletop Campaign Companion</span>
                    </p>
                  </div>

                  <hr class="is-fancy-hr">
                </div>
              </div>
            </section>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end
  end

  describe '#navigation' do
    include_examples 'should define reader', :navigation, false

    context 'when initialized with navigation: value' do
      let(:navigation) { { label: 'Sleeping King Studios' } }
      let(:options)    { super().merge(navigation: navigation) }

      it { expect(banner.navigation).to be == navigation }
    end
  end

  describe '#subtitle' do
    include_examples 'should define reader', :subtitle, nil

    context 'when initialized with subtitle: value' do
      let(:subtitle) { 'Tabletop Campaign Companion' }
      let(:options)  { super().merge(subtitle: subtitle) }

      it { expect(banner.subtitle).to be == subtitle }
    end
  end

  describe '#title' do
    include_examples 'should define reader', :title, nil

    context 'when initialized with title: value' do
      let(:title)   { 'Librum' }
      let(:options) { super().merge(title: title) }

      it { expect(banner.title).to be == title }
    end
  end
end
