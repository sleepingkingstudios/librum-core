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
      path.reduce(data) do |hsh, key|
        return nil if hsh.blank? || !hsh.respond_to?(:[])

        hsh[key]
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

      data[name]
    end
  end
end
