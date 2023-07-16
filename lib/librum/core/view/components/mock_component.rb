# frozen_string_literal: true

module Librum::Core::View::Components
  # Basic mock for stubbing out view components.
  class MockComponent < ViewComponent::Base
    # @param name [String] the name of the mocked component.
    # @param options [Hash{Symbol => Object}] additional options passed to the
    #   mock component.
    def initialize(name, **options)
      super()

      @name    = name
      @options = options
    end

    # @return [String] the name of the mocked component.
    attr_reader :name

    # @return [Hash{Symbol => Object}] additional options passed to the mock
    #   component.
    attr_reader :options

    # @return [String] the rendered component.
    def call
      formatted = options.transform_values do |value|
        value.is_a?(String) ? value : value.inspect
      end

      tag('mock', { name: name }.merge(formatted)) # rubocop:disable Rails/ContentTag
    end
  end
end
