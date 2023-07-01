# frozen_string_literal: true

require 'rails_helper'

require 'librum/core/resources/view_resource'
require 'librum/core/view/pages/resources/edit_page'

RSpec.describe Librum::Core::View::Pages::Resources::EditPage,
  type: :component \
do
  subject(:page) { described_class.new(result, resource: resource) }

  shared_context 'with data' do
    let(:data)   { { 'name' => 'Imp IV' } }
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
        <h1 class="title">Update Rocket</h1>

        <div class="box">
          <p class="has-text-centered">
            <span class="icon is-large has-text-danger">
              <i class="fas fa-2x fa-bug"></i>
            </span>
          </p>

          <h2 class="title has-text-centered has-text-danger">Missing Component Form</h2>

          <p class="has-text-centered">Rendered in Librum::Core::View::Pages::Resources::EditPage</p>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with a resource with block_component: value' do
      include_context 'with mock component', 'form'

      let(:resource) do
        Librum::Core::Resources::ViewResource.new(
          form_component: Spec::FormComponent,
          resource_name:  'rockets'
        )
      end
      let(:snapshot) do
        <<~HTML
          <h1 class="title">Update Rocket</h1>

          <mock name="form" data="{}" resource='#&lt;Resource name="rockets"&gt;'></mock>
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
            <h1 class="title">Update Imp IV</h1>

            <mock name="form" data='{"name"=&gt;"Imp IV"}' resource='#&lt;Resource name="rockets"&gt;'></mock>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end
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

  describe '#singular_resource_name' do
    include_examples 'should define reader',
      :singular_resource_name,
      -> { resource.singular_resource_name }
  end
end
