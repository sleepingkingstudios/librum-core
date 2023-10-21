# frozen_string_literal: true

module Librum::Core::View
  # Mixin for extracting the data for a scoped element.
  module DataMatching
    # @return [Object] the data for the component name.
    def matching_data
      @matching_data ||= find_matching_data
    end

    private

    def dig(*path)
      path.reduce(data) do |obj, key|
        next nil if obj.blank?

        next obj[key] if obj.is_a?(Hash)

        next obj.send(key) if obj.respond_to?(key)

        next nil unless obj.respond_to?(:[])

        obj[key]
      end
    end

    def find_data_with_brackets
      dig(*name.gsub(']', '').split('['))
    end

    def find_data_with_periods
      dig(*name.split('.'))
    end

    def find_matching_data
      return if data.blank?

      return find_data_with_periods  if name.include?('.')

      return find_data_with_brackets if name.include?('[')

      dig(name)
    end
  end
end
