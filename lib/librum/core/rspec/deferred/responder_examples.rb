# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/provider'

require 'librum/core/rspec/deferred/responses/html_response_examples'

module Librum::Core::RSpec::Deferred
  # Deferred examples for testing responders.
  module ResponderExamples
    include RSpec::SleepingKingStudios::Deferred::Provider

    UNDEFINED = Object.new.freeze
    private_constant :UNDEFINED

    deferred_context 'when the responder is provided components' do
      example_constant 'Spec::Components' do
        Module.new
      end

      before(:example) do
        stub_provider(
          Librum::Components.provider,
          :components,
          Spec::Components
        )
      end
    end

    deferred_context 'when the shared component is defined' do |component_name|
      let(:components) { Librum::Components.provider.get(:components) }
      let(:component_class) do
        next super() if defined?(super())

        Class.new(ViewComponent::Base)
      end

      before(:example) do
        *path, name = component_name.split('::')
        namespace   = path.reduce(components) do |namespace, segment|
          unless namespace.const_defined?(segment)
            namespace.const_set(segment, Module.new)
          end

          namespace.const_get(segment)
        end

        namespace.const_set(name, component_class)
      end
    end
  end
end
