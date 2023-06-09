# frozen_string_literal: true

require 'rails_helper'

require 'librum/core/resources/view_resource'
require 'librum/core/view/pages/resources/index_page'

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
        <h1 class="title">Rockets</h1>

        <div class="box">
          <p class="has-text-centered">
            <span class="icon is-large has-text-danger">
              <i class="fas fa-2x fa-bug"></i>
            </span>
          </p>

          <h2 class="title has-text-centered has-text-danger">Missing Component Table</h2>

          <p class="has-text-centered">Rendered in Librum::Core::View::Pages::Resources::IndexPage</p>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

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
          <h1 class="title">Rockets</h1>

          <mock name="table" data="[]" resource='#&lt;Resource name="rockets"&gt;'></mock>
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
            <h1 class="title">Rockets</h1>

            <mock name="table" data='[{"name"=&gt;"Imp IV", "payload"=&gt;"10 tonnes"}, {"name"=&gt;"Imp VI", "payload"=&gt;"10 tonnes"}, {"name"=&gt;"Hellhound II", "payload"=&gt;"100 tonnes"}]' resource='#&lt;Resource name="rockets"&gt;'></mock>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with resource: { resource_name: a multi-word string }' do
      let(:resource) do
        Cuprum::Rails::Resource.new(resource_name: 'rocket_parts')
      end
      let(:snapshot) do
        <<~HTML
          <h1 class="title">Rocket Parts</h1>

          <div class="box">
            <p class="has-text-centered">
              <span class="icon is-large has-text-danger">
                <i class="fas fa-2x fa-bug"></i>
              </span>
            </p>

            <h2 class="title has-text-centered has-text-danger">Missing Component Table</h2>

            <p class="has-text-centered">Rendered in Librum::Core::View::Pages::Resources::IndexPage</p>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
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
end
