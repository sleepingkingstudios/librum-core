# frozen_string_literal: true

require 'cuprum/rails/commands/resources/edit'

module Librum::Core::Commands::Resources
  # Finds and edits an entity by ID or slug with optional generated slug.
  class Edit < Cuprum::Rails::Commands::Resources::Edit
    ATTRIBUTE_NAMES_FOR_SLUG = %i[name].freeze
    private_constant :ATTRIBUTE_NAMES_FOR_SLUG

    private

    def attribute_names_for_slug
      ATTRIBUTE_NAMES_FOR_SLUG
    end

    def generate_slug(attributes:, entity:)
      return entity['slug'] unless attributes.key?('slug')

      return attributes['slug'] if attributes['slug'].present?

      Librum::Core::Commands::Attributes::GenerateSlug
        .new(attribute_names: attribute_names_for_slug)
        .call(attributes:)
    end

    def require_entity(...)
      Librum::Core::Commands::Queries::RequireEntity
        .new(collection:, require_primary_key: resource.plural?)
        .call(...)
    end

    def update_entity(attributes:, entity:)
      attributes = attributes.merge(
        'slug' => step { generate_slug(attributes:, entity:) }
      )

      super
    end
  end
end
