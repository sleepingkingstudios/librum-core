# frozen_string_literal: true

require 'librum/core/actions'
require 'librum/core/models/attributes/generate_slug'

module Librum::Core::Actions
  # Action helper for generating a slug for an entity.
  module GenerateSlug
    private

    def create_entity(attributes:)
      attributes = attributes.merge({
        'slug' => step { generate_slug(attributes) }
      })

      super(attributes: attributes)
    end

    def generate_slug(attributes)
      return success(attributes['slug']) if attributes['slug'].present?

      Librum::Core::Models::Attributes::GenerateSlug
        .new(attribute_names: slug_attributes)
        .call(attributes: attributes)
    end

    def slug_attributes
      defined?(super) ? super : :name
    end

    def update_entity(attributes:)
      if attributes.key?('slug')
        attributes = attributes.merge({
          'slug' => step { generate_slug(attributes) }
        })
      end

      super(attributes: attributes)
    end
  end
end
