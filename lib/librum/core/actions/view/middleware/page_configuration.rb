# frozen_string_literal: true

require 'cuprum'

module Librum::Core::Actions::View::Middleware
  # Abstract middleware for configuring a view page.
  class PageConfiguration < Cuprum::Command
    include Cuprum::Middleware

    # @param options [Hash{Symbol=>Object}] additional options for configuring
    #   the view page.
    def initialize(**options)
      super()

      @options = options
    end

    # @return [Hash{Symbol=>Object}] additional options for configuring the view
    #   page.
    attr_reader :options

    private

    attr_reader \
      :request,
      :result

    def merge_result
      metadata = result.respond_to?(:metadata) ? (result.metadata || {}) : {}
      page     = metadata.fetch(:page, {}).merge(page_metadata)

      Cuprum::Rails::Result.new(
        **result.properties,
        metadata: metadata.merge(page: page)
      )
    end

    def page_metadata
      {}
    end

    def process(next_command, request:)
      @request = request
      @result  = next_command.call(request: request)

      merge_result
    end
  end
end
