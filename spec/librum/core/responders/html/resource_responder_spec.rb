# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/collections'

require 'librum/core/responders/html/resource_responder'
require 'librum/core/rspec/contracts/responders/html_contracts'

RSpec.describe Librum::Core::Responders::Html::ResourceResponder do
  include Librum::Core::RSpec::Contracts::Responders::HtmlContracts

  subject(:responder) { described_class.new(**constructor_options) }

  shared_context 'when the page is defined' do |component_name|
    let(:component_class) { component_name.constantize }

    example_class component_name, Librum::Core::View::Components::Page
  end

  shared_examples 'should respond with the page when defined' \
  do |component_name, **options|
    wrap_context 'when the page is defined', component_name do
      include_contract 'should render page',
        component_name,
        **options
    end
  end

  let(:action_name)     { :implement }
  let(:controller_name) { 'CustomController' }
  let(:member_action)   { false }
  let(:resource) do
    Cuprum::Rails::Resource.new(resource_name: 'rockets')
  end
  let(:constructor_options) do
    {
      action_name:     action_name,
      controller_name: controller_name,
      member_action:   member_action,
      resource:        resource
    }
  end

  describe '.new' do
    let(:expected_keywords) do
      %i[
        action_name
        controller_name
        member_action
        resource
      ]
    end

    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(*expected_keywords)
        .and_any_keywords
    end
  end

  describe '#call' do
    let(:result)   { Cuprum::Result.new }
    let(:response) { responder.call(result) }
    let(:expected_page) do
      'View::Pages::Custom::ImplementPage'
    end

    it { expect(responder).to respond_to(:call).with(1).argument }

    describe 'with a failing result' do
      let(:error)  { Cuprum::Error.new(message: 'Something went wrong') }
      let(:result) { Cuprum::Result.new(error: error) }

      include_contract 'should render the missing page'

      include_examples 'should respond with the page when defined',
        'View::Pages::Custom::ImplementPage',
        http_status: :internal_server_error

      include_examples 'should respond with the page when defined',
        'View::Pages::Resources::ImplementPage',
        http_status: :internal_server_error

      include_examples 'should respond with the page when defined',
        'Librum::Core::View::Pages::Resources::ImplementPage',
        http_status: :internal_server_error
    end

    describe 'with a failing result with a NotFound error' do
      let(:error) do
        Cuprum::Collections::Errors::NotFound.new(
          attribute_name:  'slug',
          attribute_value: 'imp-iv',
          collection_name: 'rockets'
        )
      end
      let(:result) { Cuprum::Result.new(error: error) }
      let(:expected_flash) do
        {
          warning: {
            icon:    'exclamation-triangle',
            message: 'Rocket not found with key "imp-iv"'
          }
        }
      end

      it 'should return a redirect response' do
        expect(response)
          .to be_a Cuprum::Rails::Responses::Html::RedirectResponse
      end

      it { expect(response.flash).to be == expected_flash }

      it { expect(response.path).to be == resource.routes.index_path }

      it { expect(response.status).to be 302 } # rubocop:disable RSpec/Rails/HaveHttpStatus
    end

    describe 'with a passing result' do
      let(:value)  { { ok: true } }
      let(:result) { Cuprum::Result.new(value: value) }

      include_contract 'should render the missing page'

      include_examples 'should respond with the page when defined',
        'View::Pages::Custom::ImplementPage'

      include_examples 'should respond with the page when defined',
        'View::Pages::Resources::ImplementPage'

      include_examples 'should respond with the page when defined',
        'Librum::Core::View::Pages::Resources::ImplementPage'
    end
  end

  describe '#format' do
    include_examples 'should define reader', :format, :html
  end

  describe '#render_component' do
    let(:result)        { Cuprum::Result.new }
    let(:options)       { {} }
    let(:response)      { responder.render_component(result, **options) }
    let(:expected_page) { 'View::Pages::Custom::ImplementPage' }

    it 'should define the method' do
      expect(responder)
        .to respond_to(:render_component)
        .with(1).argument
        .and_keywords(:flash, :status)
    end

    include_contract 'should render the missing page'

    include_examples 'should respond with the page when defined',
      'View::Pages::Custom::ImplementPage'

    include_examples 'should respond with the page when defined',
      'View::Pages::Resources::ImplementPage'

    include_examples 'should respond with the page when defined',
      'Librum::Core::View::Pages::Resources::ImplementPage'
  end
end
