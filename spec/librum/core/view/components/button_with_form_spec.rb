# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::ButtonWithForm,
  type: :component \
do
  include Librum::Core::RSpec::Contracts::ComponentContracts

  subject(:form) do
    described_class.new(label: label, url: url, **options)
  end

  let(:label)   { 'Launch' }
  let(:url)     { '/rockets/0/launch' }
  let(:options) { {} }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:label, :url)
        .and_any_keywords
    end
  end

  include_contract 'should define options'

  include_contract 'should define option', :http_method, default: 'post'

  describe '#call' do
    let(:rendered) { render_inline(form) }
    let(:snapshot) do
      <<~HTML
        <form action="/rockets/0/launch" accept-charset="UTF-8" method="post">
          <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

          <button type="submit" class="button">Launch</button>
        </form>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with http_method: value' do
      let(:options) { super().merge(http_method: 'patch') }
      let(:snapshot) do
        <<~HTML
          <form action="/rockets/0/launch" accept-charset="UTF-8" method="post">
            <input type="hidden" name="_method" value="patch" autocomplete="off">

            <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

            <button type="submit" class="button">Launch</button>
          </form>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with options' do
      let(:options) { super().merge(color: 'primary', outline: true) }
      let(:snapshot) do
        <<~HTML
          <form action="/rockets/0/launch" accept-charset="UTF-8" method="post">
            <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

            <button type="submit" class="button is-primary is-outlined">Launch</button>
          </form>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#label' do
    include_examples 'should define reader', :label, -> { label }
  end

  describe '#url' do
    include_examples 'should define reader', :url, -> { url }
  end
end
