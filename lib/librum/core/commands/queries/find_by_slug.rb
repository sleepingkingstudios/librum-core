# frozen_string_literal: true

require 'cuprum/collections/errors/not_found'
require 'cuprum/collections/errors/not_unique'
require 'cuprum/command'

module Librum::Core::Commands::Queries
  # Query command to find an entity by its slug value.
  class FindBySlug < Cuprum::Command
    # @param collection [Object] The collection to query.
    def initialize(collection:)
      super()

      @collection = collection
    end

    # @return [Object] the collection to query.
    attr_reader :collection

    private

    def not_found_error(slug:)
      Cuprum::Collections::Errors::NotFound.new(
        attribute_name:  'slug',
        attribute_value: slug,
        collection_name: collection.name
      )
    end

    def not_unique_error(slug:)
      Cuprum::Collections::Errors::NotUnique.new(
        attribute_name:  'slug',
        attribute_value: slug,
        collection_name: collection.name
      )
    end

    def perform_query(slug:)
      collection.find_matching.call(limit: 2) { { slug: slug } }
    end

    def process(slug:)
      matching = step { perform_query(slug: slug) }
      matching = matching.to_a if matching.size.nil?

      case matching.size
      when 0
        failure(not_found_error(slug: slug))
      when 1
        success(matching.first)
      else
        failure(not_unique_error(slug: slug))
      end
    end
  end
end
