# frozen_string_literal: true

require 'rails_helper'

require 'librum/core/view/layouts/page'

RSpec.describe Librum::Core::View::Layouts::Page, type: :component do
  subject(:page) { described_class.new(**options).with_content(content) }

  let(:content) { 'Greetings, Starfighter!' }
  let(:options) { {} }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:alerts, :breadcrumbs, :navigation)
    end
  end

  describe '#alerts' do
    include_examples 'should define reader', :alerts, nil

    context 'when initialized with alerts: value' do
      let(:alerts) do
        {
          danger: {
            icon:    'radiation',
            message: 'Reactor temperature critical'
          },
          info:   'Initializing activation sequence'
        }
      end
      let(:options) { super().merge(alerts: alerts) }

      it { expect(page.alerts).to be == alerts }
    end
  end

  describe '#breadcrumbs' do
    include_examples 'should define reader', :breadcrumbs, false

    context 'when initialized with breadcrumbs: value' do
      let(:breadcrumbs) { [{ label: 'Home', url: '/' }] }
      let(:options)     { super().merge(breadcrumbs: breadcrumbs) }

      it { expect(page.breadcrumbs).to be == breadcrumbs }
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(page) }
    let(:snapshot) do
      <<~HTML
        <div class="page is-flex is-flex-direction-column">
          <section class="banner hero is-small">
            <div class="hero-body">
              <div class="container">
                <div>
                  <p class="title">Librum</p>

                  <p class="subtitle">Tabletop Campaign Companion</p>
                </div>

                <hr class="is-fancy-hr">
              </div>
            </div>
          </section>

          <section class="section primary-content is-flex-grow-1">
            <div class="container">
              Greetings, Starfighter!
            </div>
          </section>

          <footer class="footer has-text-centered">
            <div class="container">
              <hr class="is-fancy-hr">

              <p>What Lies Beyond The Farthest Reaches Of The Skies?</p>
            </div>
          </footer>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with after_content: value' do
      let(:after_content) { "Don't forget to like and subscribe!" }
      let(:snapshot) do
        <<~HTML
          <div class="page is-flex is-flex-direction-column">
            <section class="banner hero is-small">
              <div class="hero-body">
                <div class="container">
                  <div>
                    <p class="title">Librum</p>

                    <p class="subtitle">Tabletop Campaign Companion</p>
                  </div>

                  <hr class="is-fancy-hr">
                </div>
              </div>
            </section>

            <section class="section primary-content is-flex-grow-1">
              <div class="container">
                Greetings, Starfighter!

                Don't forget to like and subscribe!
              </div>
            </section>

            <footer class="footer has-text-centered">
              <div class="container">
                <hr class="is-fancy-hr">

                <p>What Lies Beyond The Farthest Reaches Of The Skies?</p>
              </div>
            </footer>
          </div>
        HTML
      end

      before(:example) do
        page.with_after_content { after_content }
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with alerts: value' do
      let(:alerts) do
        {
          danger: {
            icon:    'radiation',
            message: 'Reactor temperature critical'
          },
          info:   'Initializing activation sequence'
        }
      end
      let(:options) { super().merge(alerts: alerts) }
      let(:snapshot) do
        <<~HTML
          <div class="page is-flex is-flex-direction-column">
            <section class="banner hero is-small">
              <div class="hero-body">
                <div class="container">
                  <div>
                    <p class="title">Librum</p>

                    <p class="subtitle">Tabletop Campaign Companion</p>
                  </div>

                  <hr class="is-fancy-hr">
                </div>
              </div>
            </section>

            <section class="section primary-content is-flex-grow-1">
              <div class="container">
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

                Greetings, Starfighter!
              </div>
            </section>

            <footer class="footer has-text-centered">
              <div class="container">
                <hr class="is-fancy-hr">

                <p>What Lies Beyond The Farthest Reaches Of The Skies?</p>
              </div>
            </footer>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with before_content: value' do
      let(:before_content) { 'You are not currently logged in. [Log In]' }
      let(:snapshot) do
        <<~HTML
          <div class="page is-flex is-flex-direction-column">
            <section class="banner hero is-small">
              <div class="hero-body">
                <div class="container">
                  <div>
                    <p class="title">Librum</p>

                    <p class="subtitle">Tabletop Campaign Companion</p>
                  </div>

                  <hr class="is-fancy-hr">
                </div>
              </div>
            </section>

            <section class="section primary-content is-flex-grow-1">
              <div class="container">
                You are not currently logged in. [Log In]


                Greetings, Starfighter!
              </div>
            </section>

            <footer class="footer has-text-centered">
              <div class="container">
                <hr class="is-fancy-hr">

                <p>What Lies Beyond The Farthest Reaches Of The Skies?</p>
              </div>
            </footer>
          </div>
        HTML
      end

      before(:example) do
        page.with_before_content { before_content }
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with breadcrumbs: value' do
      let(:breadcrumbs) { [{ label: 'Home', url: '/' }] }
      let(:options)     { super().merge(breadcrumbs: breadcrumbs) }
      let(:snapshot) do
        <<~HTML
          <div class="page is-flex is-flex-direction-column">
            <section class="banner hero is-small">
              <div class="hero-body">
                <div class="container">
                  <div>
                    <p class="title">Librum</p>

                    <p class="subtitle">Tabletop Campaign Companion</p>
                  </div>

                  <hr class="is-fancy-hr">
                </div>
              </div>
            </section>

            <section class="section primary-content is-flex-grow-1">
              <div class="container">
                Greetings, Starfighter!
              </div>
            </section>

            <footer class="footer has-text-centered">
              <div class="container">
                <nav class="breadcrumb has-arrow-separator" aria-label="breadcrumbs">
                  <ul>
                    <li>
                      <a href="/">Home</a>
                    </li>
                  </ul>
                </nav>

                <hr class="is-fancy-hr">

                <p>What Lies Beyond The Farthest Reaches Of The Skies?</p>
              </div>
            </footer>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with navigation: value' do
      let(:navigation) { { label: 'Sleeping King Studios' } }
      let(:options)    { super().merge(navigation: navigation) }
      let(:snapshot) do
        <<~HTML
          <div class="page is-flex is-flex-direction-column">
            <section class="banner hero is-small">
              <div class="hero-body">
                <div class="container">
                  <div>
                    <p class="title">Librum</p>

                    <p class="subtitle">Tabletop Campaign Companion</p>

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

            <section class="section primary-content is-flex-grow-1">
              <div class="container">
                Greetings, Starfighter!
              </div>
            </section>

            <footer class="footer has-text-centered">
              <div class="container">
                <hr class="is-fancy-hr">

                <p>What Lies Beyond The Farthest Reaches Of The Skies?</p>
              </div>
            </footer>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#navigation' do
    include_examples 'should define reader', :navigation, false

    context 'when initialized with navigation: value' do
      let(:navigation) { { label: 'Sleeping King Studios' } }
      let(:options)    { super().merge(navigation: navigation) }

      it { expect(page.navigation).to be == navigation }
    end
  end
end
