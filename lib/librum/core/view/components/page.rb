# frozen_string_literal: true

module Librum::Core::View::Components
  # Abstract base class for view page components.
  class Page < ViewComponent::Base
    # @param result [Cuprum::Result] the result of calling the controller
    #   action.
    # @param resource [Cuprum::Rails::Resource] the current controller resource.
    # @param options [Hash{Symbol=>Object}] additional options for the page.
    def initialize(result, resource: nil, **options)
      super()

      @result   = result
      @resource = resource
      @options  = options
      @error    = result.error
      @status   = result.status
      @value    = result.value
      @metadata = result.respond_to?(:metadata) ? result.metadata : nil
    end

    # @return [Cuprum::Result] the result error.
    attr_reader :error

    # @return [Hash{Symbol=>Object}] the result metadata.
    attr_reader :metadata

    # @return [Hash{Symbol=>Object}] additional options for the page.
    attr_reader :options

    # @return [Cuprum::Rails::Resource] the current controller resource.
    attr_reader :resource

    # @return [Cuprum::Result] the result of calling the controller action.
    attr_reader :result

    # @return [:success, :failure] the result status.
    attr_reader :status

    # @return [Object] the result value.
    attr_reader :value

    # @return [true, false] if true, indicates that the component represents a
    #   full-page layout. Defaults to true.
    def is_layout? = true # rubocop:disable Naming/PredicatePrefix
  end
end
