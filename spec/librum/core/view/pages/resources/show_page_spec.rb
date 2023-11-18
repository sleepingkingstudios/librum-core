# frozen_string_literal: true

require 'rails_helper'

require 'support/rocket'

RSpec.describe Librum::Core::View::Pages::Resources::ShowPage,
  type: :component \
do
  subject(:page) { described_class.new(result, resource: resource) }

  shared_context 'with data' do
    let(:data)   { Spec::Support::Rocket.new(name: 'Imp IV', slug: 'imp-iv') }
    let(:value)  { { resource.singular_resource_name => data } }
    let(:result) { Cuprum::Result.new(value: value) }
  end

  let(:result)   { Cuprum::Result.new }
  let(:resource) { Cuprum::Rails::Resource.new(resource_name: 'rockets') }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(1).argument
        .and_keywords(:resource)
        .and_any_keywords
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(page) }
    let(:snapshot) do
      <<~HTML
        <h1 class="title">Rocket</h1>

        <div class="box">
          <p class="has-text-centered">
            <span class="icon has-text-danger is-large">
              <i class="fas fa-bug fa-2x"></i>
            </span>
          </p>

          <h2 class="title has-text-centered has-text-danger">Missing Component Block</h2>

          <p class="has-text-centered">Rendered in Librum::Core::View::Pages::Resources::ShowPage</p>
        </div>

        <p>
          <a class="has-text-link" href="/rockets" target="_self">
            <span class="icon-text">
              <span class="icon">
                <i class="fas fa-left-long"></i>
              </span>

              <span>Back to Rockets</span>
            </span>
          </a>
        </p>
      HTML
    end

    before(:example) do
      routes = resource.routes

      allow(resource).to receive_messages(
        inspect: '#<Resource name="rockets">',
        routes:  routes
      )
      allow(routes).to receive(:inspect).and_return('[routes]')
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with a plural resource with block_component: value' do
      include_context 'with mock component', 'block'

      let(:resource) do
        Librum::Core::Resources::ViewResource.new(
          block_component: Spec::BlockComponent,
          resource_name:   'rockets'
        )
      end
      let(:snapshot) do
        <<~HTML
          <h1 class="title">Rocket</h1>

          <mock name="block" data="nil" resource='#&lt;Resource name="rockets"&gt;' routes="[routes]"></mock>

          <p>
            <a class="has-text-link" href="/rockets" target="_self">
              <span class="icon-text">
                <span class="icon">
                  <i class="fas fa-left-long"></i>
                </span>

                <span>Back to Rockets</span>
              </span>
            </a>
          </p>
        HTML
      end

      before(:example) do
        allow(resource)
          .to receive(:inspect)
          .and_return('#<Resource name="rockets">')
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      wrap_context 'with data' do
        let(:snapshot) do
          <<~HTML
            <div class="level">
              <div class="level-left">
                <div class="level-item">
                  <h1 class="title">Imp IV</h1>
                </div>
              </div>

              <div class="level-right">
                <div class="level-item">
                  <a class="button is-warning is-light" href="/rockets/imp-iv/edit" target="_self">
                    Update Rocket
                  </a>
                </div>

                <div class="level-item">
                  <form action="/rockets/imp-iv" accept-charset="UTF-8" method="post">
                    <input type="hidden" name="_method" value="delete" autocomplete="off">

                    <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

                    <button type="submit" class="button is-danger is-light">Destroy Rocket</button>
                  </form>
                </div>
              </div>
            </div>

            <mock name="block" data='#&lt;Rocket name="Imp IV"&gt;' resource='#&lt;Resource name="rockets"&gt;' routes="[routes]"></mock>

            <p>
              <a class="has-text-link" href="/rockets" target="_self">
                <span class="icon-text">
                  <span class="icon">
                    <i class="fas fa-left-long"></i>
                  </span>

                  <span>Back to Rockets</span>
                </span>
              </a>
            </p>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with a singular resource with block_component: value' do
      include_context 'with mock component', 'block'

      let(:resource) do
        Librum::Core::Resources::ViewResource.new(
          block_component: Spec::BlockComponent,
          resource_name:   'rocket',
          singular:        true
        )
      end
      let(:snapshot) do
        <<~HTML
          <h1 class="title">Rocket</h1>

          <mock name="block" data="nil" resource='#&lt;Resource name="rocket"&gt;' routes="[routes]"></mock>
        HTML
      end

      before(:example) do
        allow(resource)
          .to receive(:inspect)
          .and_return('#<Resource name="rocket">')
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      wrap_context 'with data' do
        let(:snapshot) do
          <<~HTML
            <div class="level">
              <div class="level-left">
                <div class="level-item">
                  <h1 class="title">Imp IV</h1>
                </div>
              </div>

              <div class="level-right">
                <div class="level-item">
                  <a class="button is-warning is-light" href="/rocket/edit" target="_self">
                    Update Rocket
                  </a>
                </div>

                <div class="level-item">
                  <form action="/rocket" accept-charset="UTF-8" method="post">
                    <input type="hidden" name="_method" value="delete" autocomplete="off">

                    <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

                    <button type="submit" class="button is-danger is-light">Destroy Rocket</button>
                  </form>
                </div>
              </div>
            </div>

            <mock name="block" data='#&lt;Rocket name="Imp IV"&gt;' resource='#&lt;Resource name="rocket"&gt;' routes="[routes]"></mock>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with resource: { actions: without "destroy" }' do
      include_context 'with mock component', 'block'

      let(:resource) do
        Librum::Core::Resources::ViewResource.new(
          actions:         %w[edit index show launch recover update],
          block_component: Spec::BlockComponent,
          resource_name:   'rockets'
        )
      end

      before(:example) do
        allow(resource)
          .to receive(:inspect)
          .and_return('#<Resource name="rockets">')
      end

      wrap_context 'with data' do
        let(:snapshot) do
          <<~HTML
            <div class="level">
              <div class="level-left">
                <div class="level-item">
                  <h1 class="title">Imp IV</h1>
                </div>
              </div>

              <div class="level-right">
                <div class="level-item">
                  <a class="button is-warning is-light" href="/rockets/imp-iv/edit" target="_self">
                    Update Rocket
                  </a>
                </div>
              </div>
            </div>

            <mock name="block" data='#&lt;Rocket name="Imp IV"&gt;' resource='#&lt;Resource name="rockets"&gt;' routes="[routes]"></mock>

            <p>
              <a class="has-text-link" href="/rockets" target="_self">
                <span class="icon-text">
                  <span class="icon">
                    <i class="fas fa-left-long"></i>
                  </span>

                  <span>Back to Rockets</span>
                </span>
              </a>
            </p>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with resource: { actions: without "update" }' do
      include_context 'with mock component', 'block'

      let(:resource) do
        Librum::Core::Resources::ViewResource.new(
          actions:         %w[destroy index show launch recover],
          block_component: Spec::BlockComponent,
          resource_name:   'rockets'
        )
      end

      before(:example) do
        allow(resource)
          .to receive(:inspect)
          .and_return('#<Resource name="rockets">')
      end

      wrap_context 'with data' do
        let(:snapshot) do
          <<~HTML
            <div class="level">
              <div class="level-left">
                <div class="level-item">
                  <h1 class="title">Imp IV</h1>
                </div>
              </div>

              <div class="level-right">
                <div class="level-item">
                  <form action="/rockets/imp-iv" accept-charset="UTF-8" method="post">
                    <input type="hidden" name="_method" value="delete" autocomplete="off">

                    <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

                    <button type="submit" class="button is-danger is-light">Destroy Rocket</button>
                  </form>
                </div>
              </div>
            </div>

            <mock name="block" data='#&lt;Rocket name="Imp IV"&gt;' resource='#&lt;Resource name="rockets"&gt;' routes="[routes]"></mock>

            <p>
              <a class="has-text-link" href="/rockets" target="_self">
                <span class="icon-text">
                  <span class="icon">
                    <i class="fas fa-left-long"></i>
                  </span>

                  <span>Back to Rockets</span>
                </span>
              </a>
            </p>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end
  end

  describe '#resource' do
    include_examples 'should define reader', :resource, -> { resource }
  end

  describe '#resource_data' do
    include_examples 'should define reader', :resource_data, {}

    wrap_context 'with data' do
      it { expect(page.resource_data).to be == value['rocket'] }
    end
  end

  describe '#resource_name' do
    include_examples 'should define reader',
      :resource_name,
      -> { resource.resource_name }
  end

  describe '#routes' do
    let(:params) { {} }
    let(:request) do
      instance_double(ActionDispatch::Request, path_parameters: params)
    end
    let(:controller) do
      instance_double(ActionController::Base, request: request)
    end

    before(:example) do
      allow(page).to receive(:controller).and_return(controller) # rubocop:disable RSpec/SubjectStub
    end

    include_examples 'should define reader', :routes

    it 'should return the resource routes', :aggregate_failures do
      expect(page.routes).to be_a resource.routes.class

      expect(page.routes.base_path).to be == resource.routes.base_path
      expect(page.routes.wildcards).to be == resource.routes.wildcards
    end

    context 'when the request has path parameters' do
      let(:params) { { 'id' => 'custom-slug' } }

      it { expect(page.routes.wildcards).to be == params }
    end
  end

  describe '#singular_resource_name' do
    include_examples 'should define reader',
      :singular_resource_name,
      -> { resource.singular_resource_name }
  end
end
