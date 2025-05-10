# frozen_string_literal: true

require 'cuprum/command'

module Librum::Core::Commands::Queries
  # Query command to find an entity by its id or slug value.
  class FindEntity < Cuprum::Command
    UUID_PATTERN = /\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/
    private_constant :UUID_PATTERN

    # @param collection [Object] The collection to query.
    def initialize(collection:)
      super()

      @collection = collection
    end

    # @return [Object] the collection to query.
    attr_reader :collection

    private

    def process(value:)
      if value.match?(UUID_PATTERN)
        collection.find_one.call(primary_key: value)
      else
        Librum::Core::Commands::Queries::FindBySlug
          .new(collection: collection)
          .call(slug: value)
      end
    end
  end
end
