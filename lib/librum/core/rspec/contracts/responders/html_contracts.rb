# frozen_string_literal: true

require 'rspec/sleeping_king_studios/contract'

module Librum::Core::RSpec::Contracts::Responders
  module HtmlContracts
    # :nocov:

    # Contract asserting the action redirects to the previous path.
    module ShouldRedirectBackContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |fallback_location: '/', flash: {}, status: 302|
        let(:response) { responder.call(result) }
        let(:expected_flash) do
          next flash unless flash.is_a?(Proc)

          instance_exec(&flash)
        end

        it 'should redirect to the previous path' do
          expect(response)
            .to be_a Cuprum::Rails::Responses::Html::RedirectBackResponse
        end

        it { expect(response.fallback_location).to be == fallback_location }

        it { expect(response.flash).to be == expected_flash }

        it { expect(response.status).to be status }
      end
    end

    # Contract asserting the action redirects to the specified path.
    module ShouldRedirectToContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |path, flash: {}, status: 302|
        let(:response) { responder.call(result) }
        let(:expected_flash) do
          next flash unless flash.is_a?(Proc)

          instance_exec(&flash)
        end

        it 'should redirect to the specified path' do
          expect(response)
            .to be_a Cuprum::Rails::Responses::Html::RedirectResponse
        end

        it { expect(response.flash).to be == expected_flash }

        it { expect(response.path).to be == path }

        it { expect(response.status).to be status }
      end
    end

    # Contract asserting the action responds with the not found page.
    module ShouldRenderTheMissingPageContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |**options|
        let(:expected_action_name) do
          if defined?(self.options)
            return self.options.fetch(:action, action_name)
          end

          action_name
        end

        include_contract 'should render component',
          Librum::Core::View::Pages::MissingPage,
          http_status: :internal_server_error,
          **options

        it 'should set the action name' do
          expect(response.component.action_name).to be == expected_action_name
        end

        it 'should set the controller name' do
          expect(response.component.controller_name).to be == controller_name
        end

        it { expect(response.component.expected_page).to be == expected_page }
      end
    end

    # Contract asserting the action responds with a rendered view component.
    module ShouldRenderComponentContract
      extend RSpec::SleepingKingStudios::Contract

      UNDEFINED = Object.new.freeze
      private_constant :UNDEFINED

      contract do |
        component_class,
        assigns:     UNDEFINED,
        flash:       {},
        http_status: :ok,
        layout:      nil,
        &block
      |
        unless method_defined?(:response)
          let(:response) { responder.call(result) }
        end
        let(:expected_class) do
          next component_class if component_class.is_a?(Class)

          component_class.constantize
        end
        let(:expected_assigns) do
          next { 'result' => result } if assigns == UNDEFINED

          next assigns unless assigns.is_a?(Proc)

          instance_exec(&assigns)
        end
        let(:expected_flash) do
          next flash unless flash.is_a?(Proc)

          instance_exec(&flash)
        end

        it 'should respond with a rendered component' do
          expect(response)
            .to be_a Librum::Core::Responses::Html::RenderComponentResponse
        end

        it { expect(response.component).to be_a expected_class }

        it { expect(response.assigns).to be == expected_assigns }

        it { expect(response.flash).to be == expected_flash }

        it { expect(response.layout).to be == layout }

        it { expect(response.status).to be http_status }

        instance_exec(&block) if block.is_a?(Proc)
      end
    end

    # Contract asserting the action responds with a rendered view page.
    module ShouldRenderPageContract
      extend RSpec::SleepingKingStudios::Contract

      UNDEFINED = Object.new.freeze
      private_constant :UNDEFINED

      contract do |component_class, resource: UNDEFINED, **options|
        let(:expected_resource) do
          resource == UNDEFINED ? self.resource : resource
        end

        include_contract 'should render component',
          component_class,
          **options

        it { expect(response.component.resource).to be == expected_resource }

        it { expect(response.component.result).to be result }
      end
    end

    # :nocov:
  end
end
