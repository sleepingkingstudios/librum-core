# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::Responders::Html::FindView do
  subject(:service) { described_class.new(application:, libraries:) }

  let(:application) { Object.new.freeze }
  let(:libraries)   { [] }

  deferred_context 'when the application defines view paths' do
    let(:application) { Spec::MockApplication.new }

    example_class 'Spec::MockApplication' do |klass|
      klass.define_method(:view_path) do |action:, controller:|
        action     = action.titleize.gsub('/', '::')
        controller = controller.titleize.gsub('/', '::')

        "View::#{controller}::#{action}"
      end
    end
  end

  deferred_context 'when the application namespace defines view paths' do
    let(:application) { Spec::Namespace::Application.new }

    example_constant 'Spec::Namespace' do
      namespace = Module.new

      namespace.define_singleton_method(:view_path) do |action:, controller:|
        action     = action.titleize.gsub('/', '::')
        controller = controller.titleize.gsub('/', '::')

        "View::#{controller}::#{action}"
      end

      namespace
    end

    example_class 'Spec::Namespace::Application'
  end

  deferred_context 'when the application includes libraries' do
    let(:libraries) do
      [
        Spec::Engine.new('Example'),
        Spec::Engine.new('WebhooksEngine'),
        Spec::Engine.new('CustomRailtie')
      ]
    end

    example_class 'Spec::Engine', Struct.new(:name) do |klass|
      klass.define_method(:view_path) do |action:, controller:|
        action     = action.titleize.gsub('/', '::')
        controller = controller.titleize.gsub('/', '::')

        "#{name}::View::#{controller}::#{action}"
      end
    end
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:application, :libraries)
    end
  end

  describe '#application' do
    include_examples 'should define reader', :application, -> { application }
  end

  describe '#call' do
    let(:action)     { 'publish' }
    let(:controller) { 'books' }
    let(:component)  { service.call(action:, controller:) }

    it 'should define the method' do
      expect(service)
        .to respond_to(:call)
        .with(0).arguments
        .and_keywords(:action, :controller)
    end

    it { expect(component).to be nil }

    context 'when the legacy page is defined' do
      example_class 'View::Pages::Books::PublishPage', ViewComponent::Base

      it { expect(component).to be View::Pages::Books::PublishPage }
    end

    wrap_deferred 'when the application defines view paths' do # rubocop:disable RSpec/RepeatedExampleGroupBody
      it { expect(component).to be nil }

      context 'when the application defines the component' do
        example_class 'View::Books::Publish', ViewComponent::Base

        it { expect(component).to be View::Books::Publish }
      end

      context 'when the legacy page is defined' do
        example_class 'View::Pages::Books::PublishPage', ViewComponent::Base

        it { expect(component).to be View::Pages::Books::PublishPage }
      end

      context 'when multiple sources are defined' do
        example_class 'View::Books::Publish', ViewComponent::Base
        example_class 'View::Pages::Books::PublishPage', ViewComponent::Base

        it 'returns the component defined by the application' do
          expect(component).to be View::Books::Publish
        end
      end
    end

    wrap_deferred 'when the application namespace defines view paths' do # rubocop:disable RSpec/RepeatedExampleGroupBody
      it { expect(component).to be nil }

      context 'when the application defines the component' do
        example_class 'View::Books::Publish', ViewComponent::Base

        it { expect(component).to be View::Books::Publish }
      end

      context 'when the legacy page is defined' do
        example_class 'View::Pages::Books::PublishPage', ViewComponent::Base

        it { expect(component).to be View::Pages::Books::PublishPage }
      end

      context 'when multiple sources are defined' do
        example_class 'View::Books::Publish', ViewComponent::Base
        example_class 'View::Pages::Books::PublishPage', ViewComponent::Base

        it 'returns the component defined by the application' do
          expect(component).to be View::Books::Publish
        end
      end
    end

    describe 'with action: a Symbol' do
      let(:action) { :publish }

      it { expect(component).to be nil }

      context 'when the legacy page is defined' do
        example_class 'View::Pages::Books::PublishPage', ViewComponent::Base

        it { expect(component).to be View::Pages::Books::PublishPage }
      end

      wrap_deferred 'when the application defines view paths' do
        it { expect(component).to be nil }

        context 'when the application defines the component' do
          example_class 'View::Books::Publish', ViewComponent::Base

          it { expect(component).to be View::Books::Publish }
        end

        context 'when the legacy page is defined' do
          example_class 'View::Pages::Books::PublishPage', ViewComponent::Base

          it { expect(component).to be View::Pages::Books::PublishPage }
        end

        context 'when multiple sources are defined' do
          example_class 'View::Books::Publish', ViewComponent::Base
          example_class 'View::Pages::Books::PublishPage', ViewComponent::Base

          it 'returns the component defined by the application' do
            expect(component).to be View::Books::Publish
          end
        end
      end
    end

    describe 'with controller: a scoped controller' do
      let(:controller) { 'scoped/books' }

      it { expect(component).to be nil }

      context 'when the legacy page is defined' do
        example_class 'View::Pages::Scoped::Books::PublishPage',
          ViewComponent::Base

        it { expect(component).to be View::Pages::Scoped::Books::PublishPage }
      end

      wrap_deferred 'when the application defines view paths' do
        it { expect(component).to be nil }

        context 'when the application defines the component' do
          example_class 'View::Scoped::Books::Publish', ViewComponent::Base

          it { expect(component).to be View::Scoped::Books::Publish }
        end

        context 'when the legacy page is defined' do
          example_class 'View::Pages::Scoped::Books::PublishPage',
            ViewComponent::Base

          it { expect(component).to be View::Pages::Scoped::Books::PublishPage }
        end
      end
    end

    describe 'with controller: a controller belonging to a library' do
      let(:action)     { 'send' }
      let(:controller) { 'webhooks/outbound' }

      include_deferred 'when the application includes libraries'

      it { expect(component).to be nil }

      context 'when the legacy page is defined' do
        example_class 'Webhooks::View::Pages::Outbound::SendPage',
          ViewComponent::Base

        it 'should return the legacy page component' do
          expect(component).to be Webhooks::View::Pages::Outbound::SendPage
        end
      end

      context 'when the library defines the component' do
        example_class 'WebhooksEngine::View::Outbound::Send',
          ViewComponent::Base

        it { expect(component).to be WebhooksEngine::View::Outbound::Send }
      end

      context 'when multiple sources are defined' do
        example_class 'Webhooks::View::Pages::Outbound::SendPage',
          ViewComponent::Base
        example_class 'WebhooksEngine::View::Outbound::Send',
          ViewComponent::Base

        it 'returns the component defined by the library' do
          expect(component).to be WebhooksEngine::View::Outbound::Send
        end
      end

      wrap_deferred 'when the application defines view paths' do
        it { expect(component).to be nil }

        context 'when the application defines the component' do
          example_class 'View::Webhooks::Outbound::Send', ViewComponent::Base

          it { expect(component).to be View::Webhooks::Outbound::Send }
        end

        context 'when the library defines the component' do
          example_class 'WebhooksEngine::View::Outbound::Send',
            ViewComponent::Base

          it { expect(component).to be WebhooksEngine::View::Outbound::Send }
        end

        context 'when the legacy page is defined' do
          example_class 'Webhooks::View::Pages::Outbound::SendPage',
            ViewComponent::Base

          it 'should return the legacy page component' do
            expect(component).to be Webhooks::View::Pages::Outbound::SendPage
          end
        end

        context 'when multiple sources are defined' do
          example_class 'View::Webhooks::Outbound::Send', ViewComponent::Base
          example_class 'Webhooks::View::Pages::Outbound::SendPage',
            ViewComponent::Base
          example_class 'WebhooksEngine::View::Outbound::Send',
            ViewComponent::Base

          it 'returns the component defined by the application' do
            expect(component).to be View::Webhooks::Outbound::Send
          end
        end
      end
    end

    context 'when a component class is cached' do
      example_class 'View::Books::Publish',         ViewComponent::Base
      example_class 'View::Custom::Books::Publish', ViewComponent::Base

      before(:example) do
        service.call(action:, controller:)

        allow(application).to receive(:view_path) do |action:, controller:|
          action     = action.titleize.gsub('/', '::')
          controller = controller.titleize.gsub('/', '::')

          "View::Custom::#{controller}::#{action}"
        end
      end

      include_deferred 'when the application defines view paths'

      it 'should return the cached component' do
        expect(component).to be View::Books::Publish
      end

      context 'when the cache is cleared' do
        before(:example) { service.clear }

        it 'should return the matching component' do
          expect(component).to be View::Custom::Books::Publish
        end
      end
    end
  end

  describe '#clear' do
    it { expect(service).to respond_to(:clear).with(0).arguments }
  end

  describe '#libraries' do
    include_examples 'should define reader', :libraries, []

    context 'when the application defines libraries without view paths' do
      let(:libraries) { Array.new(3) { Object.new.freeze } }

      it { expect(service.libraries).to be == [] }
    end

    wrap_deferred 'when the application includes libraries' do
      it { expect(service.libraries).to be == libraries }
    end
  end
end
