# frozen_string_literal: true

require 'rails_helper'

require 'librum/core/view/layouts/page/footer'

RSpec.describe Librum::Core::View::Layouts::Page::Footer, type: :component do
  subject(:footer) { described_class.new(**options) }

  let(:options) { {} }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:breadcrumbs)
    end
  end

  describe '#breadcrumbs' do
    include_examples 'should define reader', :breadcrumbs, false

    context 'when initialized with breadcrumbs: value' do
      let(:breadcrumbs) do
        [
          {
            label: 'Home',
            url:   '/'
          },
          {
            label: 'Launch Sites',
            url:   '/launch_sites'
          },
          {
            active: true,
            label:  'Zeppelins',
            url:    '/launch_sites/zeppelins'
          }
        ]
      end
      let(:options) { super().merge(breadcrumbs: breadcrumbs) }

      it { expect(footer.breadcrumbs).to be == breadcrumbs }
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(footer) }
    let(:snapshot) do
      <<~HTML
        <footer class="footer has-text-centered">
          <div class="container">
            <hr class="is-fancy-hr">

            <p>What Lies Beyond The Farthest Reaches Of The Skies?</p>
          </div>
        </footer>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with breadcrumbs: value' do
      let(:breadcrumbs) do
        [
          {
            label: 'Home',
            url:   '/'
          },
          {
            label: 'Launch Sites',
            url:   '/launch_sites'
          },
          {
            active: true,
            label:  'Zeppelins',
            url:    '/launch_sites/zeppelins'
          }
        ]
      end
      let(:options) { super().merge(breadcrumbs: breadcrumbs) }
      let(:snapshot) do
        <<~HTML
          <footer class="footer has-text-centered">
            <div class="container">
              <nav class="breadcrumb has-arrow-separator" aria-label="breadcrumbs">
                <ul>
                  <li>
                    <a href="/">Home</a>
                  </li>

                  <li>
                    <a href="/launch_sites">Launch Sites</a>
                  </li>

                  <li class="is-active">
                    <a href="/launch_sites/zeppelins" aria-current="page">
                      Zeppelins
                    </a>
                  </li>
                </ul>
              </nav>

              <hr class="is-fancy-hr">

              <p>What Lies Beyond The Farthest Reaches Of The Skies?</p>
            </div>
          </footer>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end
end
