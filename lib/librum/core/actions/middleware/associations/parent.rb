# frozen_string_literal: true

require 'cuprum/rails/actions/middleware/associations/parent'

module Librum::Core::Actions::Middleware::Associations
  # Middleware for querying a parent association from a parameter.
  class Parent < Cuprum::Rails::Actions::Middleware::Associations::Parent
    UUID_PATTERN = /\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/
    private_constant :UUID_PATTERN

    private

    def association_collection
      repository.find_or_create(
        name:           association.name,
        qualified_name: association.qualified_name
      )
    end

    def require_parent(primary_key:)
      return super if primary_key.match?(UUID_PATTERN)

      step do
        Librum::Core::Models::Queries::FindBySlug
          .new(collection: association_collection)
          .call(slug: primary_key)
      end
    end
  end
end
