# frozen_string_literal: true

require 'cuprum/rails/commands/resources/show'

module Librum::Core::Commands::Resources
  # Finds an entity by ID or slug.
  class Show < Cuprum::Rails::Commands::Resources::Show
    private

    def require_entity(...)
      Librum::Core::Commands::Queries::RequireEntity
        .new(collection:, require_primary_key: resource.plural?)
        .call(...)
    end
  end
end
