# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Layouts::Page, type: :component do
  subject(:page) { described_class.new(**options).with_content(content) }

  let(:content) { 'Greetings, Starfighter!' }
  let(:options) { {} }

  describe '.new' do
    let(:expected_keywords) do
      %i[
        alerts
        breadcrumbs
        navigation
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
          <section class="section primary-content is-flex-grow-1">
            <div class="container">
              Greetings, Starfighter!
            </div>
          </section>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with after_content: value' do
      let(:after_content) { "Don't forget to like and subscribe!" }
      let(:snapshot) do
        <<~HTML
          <div class="page is-flex is-flex-direction-column">
            <section class="section primary-content is-flex-grow-1">
              <div class="container">
                Greetings, Starfighter!

                Don't forget to like and subscribe!
              </div>
            </section>
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
            dismissable: false,
            icon:        'radiation',
            message:     'Reactor temperature critical'
          },
          info:   'Initializing activation sequence'
        }
      end
      let(:options) { super().merge(alerts: alerts) }
      let(:snapshot) do
        <<~HTML
          <div class="page is-flex is-flex-direction-column">
            <section class="section primary-content is-flex-grow-1">
              <div class="container">
                <div class="alert notification is-danger">
                  <span class="icon-text">
                    <span class="icon">
                      <i class="fas fa-radiation"></i>
                    </span>

                    <span>Reactor temperature critical</span>
                  </span>
                </div>

                <div class="alert notification is-info" data-controller="dismissable">
                  <button data-action="click-&gt;dismissable#close" class="delete is-medium"></button>

                  Initializing activation sequence
                </div>

                Greetings, Starfighter!
              </div>
            </section>
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
            <section class="section primary-content is-flex-grow-1">
              <div class="container">
                You are not currently logged in. [Log In]


                Greetings, Starfighter!
              </div>
            </section>
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
              </div>
            </footer>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with footer_text: value' do
      let(:footer_text) do
        'Interdum feror cupidine partium magnarum Europae vincendarum'
      end
      let(:options) { super().merge(footer_text: footer_text) }
      let(:snapshot) do
        <<~HTML
          <div class="page is-flex is-flex-direction-column">
            <section class="section primary-content is-flex-grow-1">
              <div class="container">
                Greetings, Starfighter!
              </div>
            </section>

            <footer class="footer has-text-centered">
              <div class="container">
                <hr class="is-fancy-hr">

                <p>Interdum feror cupidine partium magnarum Europae vincendarum</p>
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
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with title: value' do
      let(:title)   { 'Librum' }
      let(:options) { super().merge(title: title) }
      let(:snapshot) do
        <<~HTML
          <div class="page is-flex is-flex-direction-column">
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

            <section class="section primary-content is-flex-grow-1">
              <div class="container">
                Greetings, Starfighter!
              </div>
            </section>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with subtitle: value' do
        let(:subtitle) { 'Tabletop Campaign Companion' }
        let(:options)  { super().merge(subtitle: subtitle) }
        let(:snapshot) do
          <<~HTML
            <div class="page is-flex is-flex-direction-column">
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

              <section class="section primary-content is-flex-grow-1">
                <div class="container">
                  Greetings, Starfighter!
                </div>
              </section>
            </div>
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

      it { expect(page.navigation).to be == navigation }
    end
  end

  describe '#options' do
    include_examples 'should define reader', :options, {}

    context 'when initialized with footer_text: value' do
      let(:footer_text) do
        'Interdum feror cupidine partium magnarum Europae vincendarum'
      end
      let(:options) { super().merge(footer_text: footer_text) }

      it { expect(page.options).to be == options }
    end

    context 'when initialized with subtitle: value' do
      let(:subtitle) { 'Tabletop Campaign Companion' }
      let(:options)  { super().merge(subtitle: subtitle) }

      it { expect(page.options).to be == options }
    end

    context 'when initialized with title: value' do
      let(:title)   { 'Librum' }
      let(:options) { super().merge(title: title) }

      it { expect(page.options).to be == options }
    end
  end
end
