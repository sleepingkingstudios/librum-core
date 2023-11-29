# frozen_string_literal: true

require 'rails_helper'

require 'support/rocket'

RSpec.describe Librum::Core::View::Components::Resources::DestroyForm,
  type: :component \
do
  subject(:form) do
    described_class.new(data: data, resource: resource, **options)
  end

  let(:data)     { Spec::Support::Rocket.new(name: 'Imp IV', slug: 'imp-iv') }
  let(:resource) { Cuprum::Rails::Resource.new(name: 'rockets') }
  let(:options)  { {} }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:data, :resource, :routes)
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(form) }

    describe 'with a plural resource' do
      let(:snapshot) do
        <<~HTML
          <form action="/rockets/imp-iv" accept-charset="UTF-8" method="post">
            <input type="hidden" name="_method" value="delete" autocomplete="off">

            <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

            <button type="submit" class="button is-danger">Destroy Rocket</button>
          </form>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with routes: value' do
        let(:routes) do
          Cuprum::Rails::Routing::PluralRoutes
            .new(base_path: '/path/to/rockets')
        end
        let(:options) { super().merge(routes: routes) }
        let(:snapshot) do
          <<~HTML
            <form action="/path/to/rockets/imp-iv" accept-charset="UTF-8" method="post">
              <input type="hidden" name="_method" value="delete" autocomplete="off">

              <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

              <button type="submit" class="button is-danger">Destroy Rocket</button>
            </form>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with a singular resource' do
      let(:resource) do
        Cuprum::Rails::Resource.new(name: 'rocket', singular: true)
      end
      let(:snapshot) do
        <<~HTML
          <form action="/rocket" accept-charset="UTF-8" method="post">
            <input type="hidden" name="_method" value="delete" autocomplete="off">

            <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

            <button type="submit" class="button is-danger">Destroy Rocket</button>
          </form>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with routes: value' do
        let(:routes) do
          Cuprum::Rails::Routing::SingularRoutes
            .new(base_path: '/path/to/rocket')
        end
        let(:options) { super().merge(routes: routes) }
        let(:snapshot) do
          <<~HTML
            <form action="/path/to/rocket" accept-charset="UTF-8" method="post">
              <input type="hidden" name="_method" value="delete" autocomplete="off">

              <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

              <button type="submit" class="button is-danger">Destroy Rocket</button>
            </form>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end
  end

  describe '#data' do
    include_examples 'should define reader', :data, -> { data }
  end

  describe '#resource' do
    include_examples 'should define reader', :resource, -> { resource }
  end

  describe '#routes' do
    include_examples 'should define reader', :routes

    it 'should return the resource routes', :aggregate_failures do
      expect(form.routes).to be_a(resource.routes.class)

      expect(form.routes.base_path).to be == resource.routes.base_path
    end

    context 'when initialized with routes: value' do
      let(:routes) do
        Cuprum::Rails::Routing::PluralRoutes.new(base_path: '/path/to/rockets')
      end
      let(:options) { super().merge(routes: routes) }

      it { expect(form.routes).to be == routes }
    end
  end
end
