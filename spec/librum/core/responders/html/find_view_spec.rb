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

  deferred_context 'when the provider defines components' do
    example_constant 'Spec::Components', Module.new

    before(:example) do
      stub_provider(
        Librum::Components.provider,
        :components,
        Spec::Components
      )
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

        wrap_deferred 'when the provider defines components' do
          context 'when the provider defines the matching component' do # rubocop:disable RSpec/NestedGroups
            example_class 'Spec::Components::Views::Books::Publish',
              ViewComponent::Base

            it 'returns the component defined by the application' do
              expect(component).to be View::Books::Publish
            end
          end
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

        wrap_deferred 'when the provider defines components' do
          context 'when the provider defines the matching component' do # rubocop:disable RSpec/NestedGroups
            example_class 'Spec::Components::Views::Books::Publish',
              ViewComponent::Base

            it 'returns the component defined by the application' do
              expect(component).to be View::Books::Publish
            end
          end
        end
      end
    end

    wrap_deferred 'when the provider defines components' do
      it { expect(component).to be nil }

      context 'when the provider defines the matching component' do
        example_class 'Spec::Components::Views::Books::Publish',
          ViewComponent::Base

        it { expect(component).to be Spec::Components::Views::Books::Publish }
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

        wrap_deferred 'when the provider defines components' do
          it { expect(component).to be nil }

          context 'when the provider defines the matching component' do # rubocop:disable RSpec/NestedGroups
            example_class 'Spec::Components::Views::Books::Publish',
              ViewComponent::Base

            it 'should return the shared component' do
              expect(component).to be Spec::Components::Views::Books::Publish
            end
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

      wrap_deferred 'when the provider defines components' do
        it { expect(component).to be nil }

        context 'when the provider defines the matching component' do
          example_class 'Spec::Components::Views::Scoped::Books::Publish',
            ViewComponent::Base

          it 'should return the shared component' do
            expect(component)
              .to be Spec::Components::Views::Scoped::Books::Publish
          end
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

      wrap_deferred 'when the provider defines components' do
        it { expect(component).to be nil }

        context 'when the provider defines the matching component' do
          example_class 'Spec::Components::Views::Webhooks::Outbound::Send',
            ViewComponent::Base

          it 'should return the shared component' do
            expect(component)
              .to be Spec::Components::Views::Webhooks::Outbound::Send
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

  describe '#components' do
    include_examples 'should define reader',
      :components,
      Librum::Components::Empty

    wrap_deferred 'when the provider defines components' do
      it { expect(service.components).to be Spec::Components }
    end
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

  describe '#view_paths' do
    let(:action)     { 'publish' }
    let(:controller) { 'books' }
    let(:view_paths) { service.view_paths(action:, controller:) }
    let(:legacy_path) do
      'View::Pages::Books::PublishPage'
    end
    let(:expected) do
      [legacy_path]
    end

    it 'should define the method' do
      expect(service)
        .to respond_to(:view_paths)
        .with(0).arguments
        .and_keywords(:action, :controller)
    end

    it { expect(view_paths).to be == expected }

    # rubocop:disable RSpec/RepeatedExampleGroupBody
    wrap_deferred 'when the application defines view paths' do
      let(:application_path) do
        'View::Books::Publish'
      end
      let(:expected) do
        [
          application_path,
          legacy_path
        ]
      end

      it { expect(view_paths).to be == expected }
    end

    wrap_deferred 'when the application namespace defines view paths' do
      let(:application_path) do
        'View::Books::Publish'
      end
      let(:expected) do
        [
          application_path,
          legacy_path
        ]
      end

      it { expect(view_paths).to be == expected }
    end
    # rubocop:enable RSpec/RepeatedExampleGroupBody

    wrap_deferred 'when the provider defines components' do
      let(:shared_path) do
        'Spec::Components::Views::Books::Publish'
      end
      let(:expected) do
        [
          shared_path,
          legacy_path
        ]
      end

      it { expect(view_paths).to be == expected }
    end

    context 'when multiple sources are defined' do
      let(:application_path) do
        'View::Books::Publish'
      end
      let(:shared_path) do
        'Spec::Components::Views::Books::Publish'
      end
      let(:expected) do
        [
          application_path,
          shared_path,
          legacy_path
        ]
      end

      include_deferred 'when the application defines view paths'
      include_deferred 'when the provider defines components'

      it { expect(view_paths).to be == expected }
    end

    describe 'with controller: a scoped controller' do
      let(:controller) { 'scoped/books' }
      let(:legacy_path) do
        'View::Pages::Scoped::Books::PublishPage'
      end

      it { expect(view_paths).to be == expected }

      # rubocop:disable RSpec/RepeatedExampleGroupBody
      wrap_deferred 'when the application defines view paths' do
        let(:application_path) do
          'View::Scoped::Books::Publish'
        end
        let(:expected) do
          [
            application_path,
            legacy_path
          ]
        end

        it { expect(view_paths).to be == expected }
      end

      wrap_deferred 'when the application namespace defines view paths' do
        let(:application_path) do
          'View::Scoped::Books::Publish'
        end
        let(:expected) do
          [
            application_path,
            legacy_path
          ]
        end

        it { expect(view_paths).to be == expected }
      end
      # rubocop:enable RSpec/RepeatedExampleGroupBody

      wrap_deferred 'when the provider defines components' do
        let(:shared_path) do
          'Spec::Components::Views::Scoped::Books::Publish'
        end
        let(:expected) do
          [
            shared_path,
            legacy_path
          ]
        end

        it { expect(view_paths).to be == expected }
      end

      context 'when multiple sources are defined' do
        let(:application_path) do
          'View::Scoped::Books::Publish'
        end
        let(:shared_path) do
          'Spec::Components::Views::Scoped::Books::Publish'
        end
        let(:expected) do
          [
            application_path,
            shared_path,
            legacy_path
          ]
        end

        include_deferred 'when the application defines view paths'
        include_deferred 'when the provider defines components'

        it { expect(view_paths).to be == expected }
      end
    end

    describe 'with controller: a controller belonging to a library' do
      let(:action)     { 'send' }
      let(:controller) { 'webhooks/outbound' }
      let(:library_path) do
        'WebhooksEngine::View::Outbound::Send'
      end
      let(:legacy_path) do
        'Webhooks::View::Pages::Outbound::SendPage'
      end
      let(:expected) do
        [
          library_path,
          legacy_path
        ]
      end

      include_deferred 'when the application includes libraries'

      it { expect(view_paths).to be == expected }

      # rubocop:disable RSpec/RepeatedExampleGroupBody
      wrap_deferred 'when the application defines view paths' do
        let(:application_path) do
          'View::Webhooks::Outbound::Send'
        end
        let(:expected) do
          [
            application_path,
            library_path,
            legacy_path
          ]
        end

        it { expect(view_paths).to be == expected }
      end

      wrap_deferred 'when the application namespace defines view paths' do
        let(:application_path) do
          'View::Webhooks::Outbound::Send'
        end
        let(:expected) do
          [
            application_path,
            library_path,
            legacy_path
          ]
        end

        it { expect(view_paths).to be == expected }
      end
      # rubocop:enable RSpec/RepeatedExampleGroupBody

      wrap_deferred 'when the provider defines components' do
        let(:shared_path) do
          'Spec::Components::Views::Webhooks::Outbound::Send'
        end
        let(:expected) do
          [
            library_path,
            shared_path,
            legacy_path
          ]
        end

        it { expect(view_paths).to be == expected }
      end

      context 'when multiple sources are defined' do
        let(:application_path) do
          'View::Webhooks::Outbound::Send'
        end
        let(:shared_path) do
          'Spec::Components::Views::Webhooks::Outbound::Send'
        end
        let(:expected) do
          [
            application_path,
            library_path,
            shared_path,
            legacy_path
          ]
        end

        include_deferred 'when the application defines view paths'
        include_deferred 'when the provider defines components'

        it { expect(view_paths).to be == expected }
      end
    end
  end
end
