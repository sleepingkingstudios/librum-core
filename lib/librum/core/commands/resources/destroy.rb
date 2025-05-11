# frozen_string_literal: true

require 'cuprum/rails/commands/resources/destroy'

module Librum::Core::Commands::Resources
  # Removes an entity by ID or slug.
  class Destroy < Cuprum::Rails::Commands::Resources::Destroy
    private

    def require_entity(...)
      Librum::Core::Commands::Queries::RequireEntity
        .new(collection:, require_primary_key: resource.plural?)
        .call(...)
    end
  end
end
