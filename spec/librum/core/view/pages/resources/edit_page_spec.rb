# frozen_string_literal: true

require 'rails_helper'

require 'stannum/errors'

RSpec.describe Librum::Core::View::Pages::Resources::EditPage,
  type: :component \
do
  subject(:page) { described_class.new(result, resource: resource) }

  shared_context 'with data' do
    let(:data)   { { 'name' => 'Imp IV' } }
    let(:value)  { { resource.singular_name => data } }
    let(:result) { Cuprum::Result.new(value: value) }
  end

  shared_context 'with errors' do
    let(:errors) do
      Stannum::Errors.new.add('spec.error', message: 'Something went wrong')
    end
    let(:error) do
      Cuprum::Collections::Errors::InvalidParameters.new(
        command: Cuprum::Command.new,
        errors:  errors
      )
    end
    let(:result) { Cuprum::Result.new(error: error) }
  end

  let(:result)   { Cuprum::Result.new }
  let(:resource) { Cuprum::Rails::Resource.new(name: 'rockets') }

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
            <span class="icon has-text-danger is-large">
              <i class="fas fa-bug fa-2x"></i>
            </span>
          </p>

          <h2 class="title has-text-centered has-text-danger">Missing Component Form</h2>

          <p class="has-text-centered">Rendered in Librum::Core::View::Pages::Resources::EditPage</p>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with a resource with form_component: value' do
      include_context 'with mock component', 'form'

      let(:resource) do
        Librum::Core::Resources::ViewResource.new(
          form_component: Spec::FormComponent,
          name:           'rockets'
        )
      end
      let(:snapshot) do
        <<~HTML
          <h1 class="title">Update Rocket</h1>

          <mock name="form" action="edit" data="nil" errors="nil" resource='#&lt;Resource name="rockets"&gt;' routes="[routes]"></mock>
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
            <h1 class="title">Update Imp IV</h1>

            <mock name="form" action="edit" data='{"rocket"=&gt;{"name"=&gt;"Imp IV"}}' errors="nil" resource='#&lt;Resource name="rockets"&gt;' routes="[routes]"></mock>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      wrap_context 'with errors' do
        let(:snapshot) do
          <<~HTML
            <h1 class="title">Update Rocket</h1>

            <mock name="form" action="edit" data="nil" errors="#&lt;Errors&gt;" resource='#&lt;Resource name="rockets"&gt;' routes="[routes]"></mock>
          HTML
        end

        before(:example) do
          allow(errors).to receive_messages(
            inspect:       '#<Errors>',
            with_messages: errors
          )
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end
  end

  describe '#form_errors' do
    include_examples 'should define reader', :form_errors, nil

    wrap_context 'with errors' do
      it { expect(page.form_errors).to be == errors }
    end
  end

  describe '#resource_data' do
    include_examples 'should define reader', :resource_data, {}

    wrap_context 'with data' do
      it { expect(page.resource_data).to be == value['rocket'] }
    end
  end
end
