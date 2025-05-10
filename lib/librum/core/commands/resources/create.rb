# frozen_string_literal: true

require 'cuprum/rails/commands/resources/create'

module Librum::Core::Commands::Resources
  # Builds and persists an entity with generated uuid ID and slug.
  class Create < Cuprum::Rails::Commands::Resources::Create
    ATTRIBUTE_NAMES_FOR_SLUG = %i[name].freeze
    private_constant :ATTRIBUTE_NAMES_FOR_SLUG

    private

    def attribute_names_for_slug
      ATTRIBUTE_NAMES_FOR_SLUG
    end

    def build_entity(attributes:)
      attributes = attributes.merge(
        'id'   => step { generate_uuid(attributes) },
        'slug' => step { generate_slug(attributes) }
      )

      super
    end

    def generate_slug(attributes)
      return attributes['slug'] if attributes.key?('slug')

      Librum::Core::Commands::Attributes::GenerateSlug
        .new(attribute_names: attribute_names_for_slug)
        .call(attributes:)
    end

    def generate_uuid(attributes)
      return attributes['id'] if attributes['id'].present?

      SecureRandom.uuid_v7
    end
  end
end
