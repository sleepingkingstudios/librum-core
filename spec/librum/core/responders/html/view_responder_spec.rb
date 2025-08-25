# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/rspec/deferred/responder_examples'

RSpec.describe Librum::Core::Responders::Html::ViewResponder do
  include Cuprum::Rails::RSpec::Deferred::ResponderExamples
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

  let(:constructor_options) do
    {
      action_name: action_name,
      controller:  controller,
      request:     request
    }
  end

  include_deferred 'should implement the Responder methods'

  describe '#call' do
    let(:controller_name) { controller.class.name }
    let(:controller) { CustomController.new }
    let(:result)     { Cuprum::Result.new }
    let(:response)   { responder.call(result) }
    let(:expected_page) do
      'View::Pages::Custom::ImplementPage'
    end

    example_class 'CustomController', 'Spec::ExampleController'

    include_contract 'should render the missing page'

    include_examples 'should respond with the page when defined',
      'View::Pages::Custom::ImplementPage'

    describe 'with a failing result' do
      let(:error)  { Cuprum::Error.new(message: 'Something went wrong') }
      let(:result) { Cuprum::Result.new(error: error) }

      include_contract 'should render the missing page'

      include_examples 'should respond with the page when defined',
        'View::Pages::Custom::ImplementPage',
        http_status: :internal_server_error
    end

    describe 'with a passing result' do
      let(:value)  { { ok: true } }
      let(:result) { Cuprum::Result.new(value: value) }

      include_contract 'should render the missing page'

      include_examples 'should respond with the page when defined',
        'View::Pages::Custom::ImplementPage'
    end
  end

  describe '#format' do
    include_examples 'should define reader', :format, :html
  end

  describe '#render_component' do
    let(:controller_name) { controller.class.name }
    let(:controller)    { CustomController.new }
    let(:result)        { Cuprum::Result.new }
    let(:options)       { {} }
    let(:response)      { responder.render_component(result, **options) }
    let(:expected_page) { 'View::Pages::Custom::ImplementPage' }

    example_class 'CustomController', 'Spec::ExampleController'

    it 'should define the method' do
      expect(responder)
        .to respond_to(:render_component)
        .with(1).argument
        .and_keywords(:flash, :status)
    end

    include_contract 'should render the missing page'

    include_examples 'should respond with the page when defined',
      'View::Pages::Custom::ImplementPage'

    context 'when the action has multiple words' do
      let(:action_name)   { :go_fish }
      let(:expected_page) { 'View::Pages::Custom::GoFishPage' }

      include_contract 'should render the missing page'

      include_examples 'should respond with the page when defined',
        'View::Pages::Custom::GoFishPage'
    end

    context 'when the controller belongs to an engine' do
      let(:controller_name) { 'Librum::Core::CustomController' }
      let(:expected_page) do
        'Librum::Core::View::Pages::Custom::ImplementPage'
      end

      before(:example) do
        allow(CustomController).to receive(:name).and_return(controller_name)
      end

      include_contract 'should render the missing page'

      include_examples 'should respond with the page when defined',
        'Librum::Core::View::Pages::Custom::ImplementPage'

      context 'when the controller has a namespace' do
        let(:controller_name) { 'Librum::Core::Namespace::CustomController' }
        let(:expected_page) do
          'Librum::Core::View::Pages::Namespace::Custom::ImplementPage'
        end

        include_contract 'should render the missing page'

        include_examples 'should respond with the page when defined',
          'Librum::Core::View::Pages::Namespace::Custom::ImplementPage'
      end
    end

    context 'when the controller has a namespace' do
      let(:controller_name) { 'Namespace::CustomController' }
      let(:expected_page)   { 'View::Pages::Namespace::Custom::ImplementPage' }

      before(:example) do
        allow(CustomController).to receive(:name).and_return(controller_name)
      end

      include_contract 'should render the missing page'

      include_examples 'should respond with the page when defined',
        'View::Pages::Namespace::Custom::ImplementPage'
    end

    context 'when the result metadata is nil' do
      let(:result) { Cuprum::Rails::Result.new(metadata: nil) }

      include_contract 'should render the missing page'

      include_examples 'should respond with the page when defined',
        'View::Pages::Custom::ImplementPage'
    end

    context 'when the result has metadata' do
      let(:value) do
        {
          'book' => {
            title:  'Gideon the Ninth',
            author: 'Tammsyn Muir'
          }
        }
      end
      let(:metadata) do
        {
          page:    { title: 'The Locked Tomb Series' },
          session: { token: '12345' }
        }
      end
      let(:result) do
        Cuprum::Rails::Result.new(value: value, metadata: metadata)
      end
      let(:assigns) do
        {
          'page'    => { title: 'The Locked Tomb Series' },
          'result'  => result,
          'session' => { token: '12345' }
        }
      end

      include_contract 'should render the missing page',
        assigns: -> { assigns }

      include_examples 'should respond with the page when defined',
        'View::Pages::Custom::ImplementPage',
        assigns: -> { assigns }
    end

    context 'when the result value is a Hash with metadata' do
      let(:value) do
        {
          'book'     => {
            title:  'Gideon the Ninth',
            author: 'Tammsyn Muir'
          },
          '_page'    => { title: 'The Locked Tomb Series' },
          '_session' => { token: '12345' }
        }
      end
      let(:result) { Cuprum::Result.new(value: value) }
      let(:assigns) do
        {
          'page'    => { title: 'The Locked Tomb Series' },
          'result'  => result,
          'session' => { token: '12345' }
        }
      end

      include_contract 'should render the missing page',
        assigns: -> { assigns }

      include_examples 'should respond with the page when defined',
        'View::Pages::Custom::ImplementPage',
        assigns: -> { assigns }
    end

    context 'when the result value is a ViewComponent' do
      let(:component) { Spec::CustomComponent.new }
      let(:result)    { Cuprum::Result.new(value: component) }

      example_class 'Spec::CustomComponent', ViewComponent::Base

      include_contract 'should render component',
        'Spec::CustomComponent'

      describe 'with flash: value' do
        let(:flash) do
          {
            alert:  'Reactor temperature critical',
            notice: 'Initializing activation sequence'
          }
        end
        let(:options) { super().merge(flash: flash) }

        it { expect(response.flash).to be == flash }
      end

      describe 'with layout: value' do
        let(:layout)  { 'custom_layout' }
        let(:options) { super().merge(layout: layout) }

        it { expect(response.layout).to be == layout }
      end

      describe 'with status: value' do
        let(:status)  { :created }
        let(:options) { super().merge(status: status) }

        it { expect(response.status).to be status }
      end
    end

    describe 'with a ViewComponent' do
      let(:component) { Spec::CustomComponent.new }
      let(:response)  { responder.render_component(component, **options) }

      example_class 'Spec::CustomComponent', ViewComponent::Base

      include_contract 'should render component',
        'Spec::CustomComponent',
        assigns: {}

      describe 'with flash: value' do
        let(:flash) do
          {
            alert:  'Reactor temperature critical',
            notice: 'Initializing activation sequence'
          }
        end
        let(:options) { super().merge(flash: flash) }

        it { expect(response.flash).to be == flash }
      end

      describe 'with layout: value' do
        let(:layout)  { 'custom_layout' }
        let(:options) { super().merge(layout: layout) }

        it { expect(response.layout).to be == layout }
      end

      describe 'with status: value' do
        let(:status)  { :created }
        let(:options) { super().merge(status: status) }

        it { expect(response.status).to be status }
      end
    end

    describe 'with action: value' do
      let(:action)  { 'execute' }
      let(:options) { super().merge(action: action) }

      include_contract 'should render the missing page'

      include_examples 'should respond with the page when defined',
        'View::Pages::Custom::ExecutePage'
    end

    describe 'with flash: value' do
      let(:flash) do
        {
          alert:  'Reactor temperature critical',
          notice: 'Initializing activation sequence'
        }
      end
      let(:options) { super().merge(flash: flash) }

      it { expect(response.flash).to be == flash }
    end

    describe 'with layout: value' do
      let(:layout)  { 'custom_layout' }
      let(:options) { super().merge(layout: layout) }

      it { expect(response.layout).to be == layout }
    end

    describe 'with status: value' do
      let(:status)  { :created }
      let(:options) { super().merge(status: status) }

      it { expect(response.status).to be :internal_server_error }
    end
  end
end
