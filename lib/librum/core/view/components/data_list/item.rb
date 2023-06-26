# frozen_string_literal: true

require 'librum/core/view/components/data_field'
require 'librum/core/view/components/data_list'

module Librum::Core::View::Components
  # Component for rendering an item in a data list.
  class DataList::Item < Librum::Core::View::Components::DataField
    # @param data [Hash{String=>Object}] the data used to render the list item.
    # @param field [View::Components::DataField::FieldDefinition] the
    #   configuration object for rendering the list item.
    def initialize(data:, field:, **options)
      super(
        data:  data,
        field: field,
        **options
      )
    end

    private

    def render_envelope?
      if field_value.blank? && default.present?
        return !default_value.is_a?(ViewComponent::Base)
      end

      !field_value.is_a?(ViewComponent::Base)
    end
  end
end
