# frozen_string_literal: true

require 'cuprum/rails/commands/require_entity'

module Librum::Core::Commands::Queries
  # Query command to require a unique entity by scope, id, or slug.
  class RequireEntity < Cuprum::Rails::Commands::RequireEntity
    private

    # Finds an entity by a unique identifier.
    #
    # This method can be overridden in a subclass to change the query behavior,
    # such as to enable querying by a non-private key identifier.
    #
    # @param value [Object] the identifier to query by.
    #
    # @return [Cuprum::Result] the result of the query.
    def find_entity_by_identifier(value)
      Librum::Core::Commands::Queries::FindEntity
        .new(collection:)
        .call(value:)
    end
  end
end
