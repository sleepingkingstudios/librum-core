# frozen_string_literal: true

require 'rails_helper'

require 'view_component'

require 'librum/core/rspec/utils/pretty_render'
require 'librum/core/view/components/identity_component'

RSpec.describe Librum::Core::RSpec::Utils::PrettyRender do
  subject(:renderer) { described_class.new }

  describe '#call' do
    include ViewComponent::TestHelpers

    let(:contents) { '<hr>' }
    let(:component) do
      Librum::Core::View::Components::IdentityComponent.new(contents)
    end
    let(:document) { render_inline(component) }
    let(:rendered) { renderer.call(document) }
    let(:expected) do
      <<~HTML
        #{contents.strip}
      HTML
    end

    example_class 'Spec::Component', ViewComponent::Base do |klass|
      klass.define_method(:initialize) { |contents| @contents = contents }

      klass.attr_reader :contents

      klass.define_method(:call) { contents }
    end

    it { expect(renderer).to respond_to(:call).with(1).argument }

    it { expect(rendered).to be == expected }

    describe 'with a tag with attributes' do
      let(:contents) { '<hr class="is-fancy-hr" style="fancy: true;">' }

      it { expect(rendered).to be == expected }
    end

    describe 'with a tag with children' do
      let(:contents) do
        <<~HTML
          <ul>
            <li>Ichi</li>
            <li>Ni</li>
            <li>San</li>
          </ul>
        HTML
      end
      let(:expected) do
        <<~HTML
          <ul>
            <li>Ichi</li>

            <li>Ni</li>

            <li>San</li>
          </ul>
        HTML
      end

      it { expect(rendered).to be == expected }

      describe 'with inconsistent whitespace' do
        let(:contents) do
          <<~HTML
            <ul>
              <li>Ichi</li>
                  <li>Ni</li>


              <li>San</li>
            </ul>
          HTML
        end

        it { expect(rendered).to be == expected }
      end
    end

    describe 'with a tag with children and text' do
      let(:contents) do
        <<~HTML
          <span>
            <i class="icon icon-rocket"></i>

            Launch Rocket
          </span>
        HTML
      end

      it { expect(rendered).to be == expected }
    end

    describe 'with a tag with multiline text' do
      let(:contents) do
        <<~HTML
          <p>
            Expected: true
              Actual: false
          </p>
        HTML
      end

      it { expect(rendered).to be == expected }
    end

    describe 'with a tag with short text' do
      let(:contents) { '<span>Ichi</span>' }

      it { expect(rendered).to be == expected }

      describe 'with whitespace' do
        let(:contents) { "<span>\tIchi  </span>" }

        it { expect(rendered).to be == expected }
      end
    end

    describe 'with a list of tags' do
      let(:contents) do
        <<~HTML
          <span>Ichi</span>
          <span>Ni</span>
          <span>San</span>
        HTML
      end
      let(:expected) do
        <<~HTML
          <span>Ichi</span>

          <span>Ni</span>

          <span>San</span>
        HTML
      end

      it { expect(rendered).to be == expected }

      describe 'with inconsistent whitespace' do
        let(:contents) do
          <<~HTML
            <span>Ichi</span>


              <span>Ni</span>
            <span>San</span>

          HTML
        end

        it { expect(rendered).to be == expected }
      end
    end

    describe 'with a complex document' do
      let(:contents) do
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
            <a href="/launch_sites/zeppelins" aria-current="page">Zeppelins</a>
          </li>

            </ul>
          </nav>


              <hr class="is-fancy-hr">

              <p>What Lies Beyond The Farthest Reaches Of The Skies?</p>
            </div>
          </footer>
        HTML
      end
      let(:expected) do
        <<~HTML
          <footer>
            <div>
              <nav>
                <ul>
                  <li>
                    <a href="/">Home</a>
                  </li>

                  <li>
                    <a href="/launch_sites">Launch Sites</a>
                  </li>

                  <li>
                    <a href="/launch_sites/zeppelins" aria-current="page">Zeppelins</a>
                  </li>
                </ul>
              </nav>

              <hr class="is-fancy-hr">

              <p>What Lies Beyond The Farthest Reaches Of The Skies?</p>
            </div>
          </footer>
        HTML
      end

      it { expect(rendered).to be == expected }
    end
  end
end
