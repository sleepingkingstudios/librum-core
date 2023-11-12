# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Pages::Resources::IndexPage,
  type: :component \
do
  subject(:page) { described_class.new(result, resource: resource) }

  shared_context 'with data' do
    let(:value) do
      {
        'rockets' => [
          {
            'name'    => 'Imp IV',
            'payload' => '10 tonnes'
          },
          {
            'name'    => 'Imp VI',
            'payload' => '10 tonnes'
          },
          {
            'name'    => 'Hellhound II',
            'payload' => '100 tonnes'
          }
        ]
      }
    end
  end

  let(:value)    { {} }
  let(:result)   { Cuprum::Rails::Result.new(value: value) }
  let(:resource) { Cuprum::Rails::Resource.new(resource_name: 'rockets') }
  let(:rendered) { render_inline(page) }

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
        <div class="level">
          <div class="level-left">
            <div class="level-item">
              <h1 class="title">Rockets</h1>
            </div>
          </div>

          <div class="level-right">
            <div class="level-item">
              <a class="button is-primary is-light" href="/rockets/new" target="_self">
                Create Rocket
              </a>
            </div>
          </div>
        </div>

        <div class="box">
          <p class="has-text-centered">
            <span class="icon has-text-danger is-large">
              <i class="fas fa-bug fa-2x"></i>
            </span>
          </p>

          <h2 class="title has-text-centered has-text-danger">Missing Component Table</h2>

          <p class="has-text-centered">Rendered in Librum::Core::View::Pages::Resources::IndexPage</p>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with resource: { actions: without "create" }' do
      let(:resource) do
        Cuprum::Rails::Resource.new(
          actions:       %w[index show launch recover],
          resource_name: 'rockets'
        )
      end
      let(:snapshot) do
        <<~HTML
          <h1 class="title">Rockets</h1>

          <div class="box">
            <p class="has-text-centered">
              <span class="icon has-text-danger is-large">
                <i class="fas fa-bug fa-2x"></i>
              </span>
            </p>

            <h2 class="title has-text-centered has-text-danger">Missing Component Table</h2>

            <p class="has-text-centered">Rendered in Librum::Core::View::Pages::Resources::IndexPage</p>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with resource: { resource_name: a multi-word string }' do
      let(:resource) do
        Cuprum::Rails::Resource.new(resource_name: 'rocket_parts')
      end
      let(:snapshot) do
        <<~HTML
          <div class="level">
            <div class="level-left">
              <div class="level-item">
                <h1 class="title">Rocket Parts</h1>
              </div>
            </div>

            <div class="level-right">
              <div class="level-item">
                <a class="button is-primary is-light" href="/rocket_parts/new" target="_self">
                  Create Rocket Part
                </a>
              </div>
            </div>
          </div>

          <div class="box">
            <p class="has-text-centered">
              <span class="icon has-text-danger is-large">
                <i class="fas fa-bug fa-2x"></i>
              </span>
            </p>

            <h2 class="title has-text-centered has-text-danger">Missing Component Table</h2>

            <p class="has-text-centered">Rendered in Librum::Core::View::Pages::Resources::IndexPage</p>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with resource: { table_component: value }' do
      include_context 'with mock component', 'table'

      let(:resource) do
        Librum::Core::Resources::ViewResource.new(
          resource_name:   'rockets',
          table_component: Spec::TableComponent
        )
      end
      let(:snapshot) do
        <<~HTML
          <div class="level">
            <div class="level-left">
              <div class="level-item">
                <h1 class="title">Rockets</h1>
              </div>
            </div>

            <div class="level-right">
              <div class="level-item">
                <a class="button is-primary is-light" href="/rockets/new" target="_self">
                  Create Rocket
                </a>
              </div>
            </div>
          </div>

          <mock name="table" data="[]" resource='#&lt;Resource name="rockets"&gt;' routes="[routes]"></mock>
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

      wrap_context 'with data' do
        let(:snapshot) do
          <<~HTML
            <div class="level">
              <div class="level-left">
                <div class="level-item">
                  <h1 class="title">Rockets</h1>
                </div>
              </div>

              <div class="level-right">
                <div class="level-item">
                  <a class="button is-primary is-light" href="/rockets/new" target="_self">
                    Create Rocket
                  </a>
                </div>
              </div>
            </div>

            <mock name="table" data='[{"name"=&gt;"Imp IV", "payload"=&gt;"10 tonnes"}, {"name"=&gt;"Imp VI", "payload"=&gt;"10 tonnes"}, {"name"=&gt;"Hellhound II", "payload"=&gt;"100 tonnes"}]' resource='#&lt;Resource name="rockets"&gt;' routes="[routes]"></mock>
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
    include_examples 'should define reader', :resource_data, []

    wrap_context 'with data' do
      it { expect(page.resource_data).to be == value['rockets'] }
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
