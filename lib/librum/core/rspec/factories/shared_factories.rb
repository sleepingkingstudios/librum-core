# frozen_string_literal: true

require 'librum/core/rspec/factories'

module Librum::Core::RSpec::Factories
  # Module for defining shared factory definitions.
  module SharedFactories
    # Value class for a factory definition.
    DEFINITION = Struct.new(:name, :options, :block, keyword_init: true)
    private_constant :DEFINITION

    # Adds the shared factory definitions to FactoryBot.
    def define_factories
      configured = factory_definitions

      FactoryBot.define do
        configured.each do |definition|
          next if FactoryBot.factories.any? do |factory|
            factory.name == definition.name
          end

          factory(definition.name, **definition.options, &definition.block)
        end
      end
    end

    # Defines a shared FactoryBot factory.
    #
    # @param factory_name [Symbol] the name of the factory to define.
    # @param options [Hash{Symbol=>Object}] additional options to pass to the
    #   factory definition.
    #
    # @yield the block to pass to the factory definition.
    def factory(factory_name, **options, &block)
      factory_definitions << DEFINITION.new(
        name:    factory_name,
        options: options,
        block:   block
      )

      factory_name
    end

    private

    def factory_definitions
      @factory_definitions ||= []
    end
  end
end
