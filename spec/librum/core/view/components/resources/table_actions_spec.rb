# frozen_string_literal: true

require 'rails_helper'

require 'support/rocket'

RSpec.describe Librum::Core::View::Components::Resources::TableActions,
  type: :component \
do
  subject(:component) { described_class.new(**constructor_options) }

  let(:data)     { Spec::Support::Rocket.new(name: 'Imp IV', slug: 'imp-iv') }
  let(:resource) { Cuprum::Rails::Resource.new(resource_name: 'rockets') }
  let(:constructor_options) do
    {
      data:     data,
      resource: resource
    }
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:data, :resource)
        .and_any_keywords
    end
  end

  describe '#actions' do
    include_examples 'should define reader', :actions, -> { resource.actions }
  end

  describe '#call' do
    let(:rendered) { render_inline(component) }
    let(:snapshot) do
      <<~HTML
        <div class="buttons" style="margin-top: -.125rem; margin-bottom: -.625rem;">
          <a class="is-small button is-link is-light" href="/rockets/imp-iv" target="_self">
            Show
          </a>

          <a class="is-small button is-warning is-light" href="/rockets/imp-iv/edit" target="_self">
            Update
          </a>

          <form action="/rockets/imp-iv" accept-charset="UTF-8" method="post">
            <input type="hidden" name="_method" value="delete" autocomplete="off">

            <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

            <button type="submit" class="button is-danger is-light is-small">Destroy</button>
          </form>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with resource: { actions: without "destroy" }' do
      let(:resource) do
        Cuprum::Rails::Resource.new(
          actions:       %w[edit index show launch recover update],
          resource_name: 'rockets'
        )
      end
      let(:snapshot) do
        <<~HTML
          <div class="buttons" style="margin-top: -.125rem; margin-bottom: -.625rem;">
            <a class="is-small button is-link is-light" href="/rockets/imp-iv" target="_self">
              Show
            </a>

            <a class="is-small button is-warning is-light" href="/rockets/imp-iv/edit" target="_self">
              Update
            </a>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with resource: { actions: without "show" }' do
      let(:resource) do
        Cuprum::Rails::Resource.new(
          actions:       %w[destroy edit index launch recover update],
          resource_name: 'rockets'
        )
      end
      let(:snapshot) do
        <<~HTML
          <div class="buttons" style="margin-top: -.125rem; margin-bottom: -.625rem;">
            <a class="is-small button is-warning is-light" href="/rockets/imp-iv/edit" target="_self">
              Update
            </a>

            <form action="/rockets/imp-iv" accept-charset="UTF-8" method="post">
              <input type="hidden" name="_method" value="delete" autocomplete="off">

              <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

              <button type="submit" class="button is-danger is-light is-small">Destroy</button>
            </form>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with resource: { actions: without "update" }' do
      let(:resource) do
        Cuprum::Rails::Resource.new(
          actions:       %w[destroy index launch recover show],
          resource_name: 'rockets'
        )
      end
      let(:snapshot) do
        <<~HTML
          <div class="buttons" style="margin-top: -.125rem; margin-bottom: -.625rem;">
            <a class="is-small button is-link is-light" href="/rockets/imp-iv" target="_self">
              Show
            </a>

            <form action="/rockets/imp-iv" accept-charset="UTF-8" method="post">
              <input type="hidden" name="_method" value="delete" autocomplete="off">

              <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

              <button type="submit" class="button is-danger is-light is-small">Destroy</button>
            </form>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#data' do
    include_examples 'should define reader', :data, -> { data }
  end

  describe '#resource' do
    include_examples 'should define reader', :resource, -> { resource }
  end

  describe '#singular_resource_name' do
    include_examples 'should define reader',
      :singular_resource_name,
      -> { resource.singular_resource_name }
  end
end