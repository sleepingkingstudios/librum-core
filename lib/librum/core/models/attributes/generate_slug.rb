# frozen_string_literal: true

require 'cuprum'

module Librum::Core::Models::Attributes
  # Generates a URL-friendly slug using the configured attribute names.
  class GenerateSlug < Cuprum::Command
    EXCLUDED_CHARACTERS_PATTERN = /[^a-z0-9-]/
    private_constant :EXCLUDED_CHARACTERS_PATTERN

    # @param attribute_names [String, Symbol, Array<String, Symbol>] The name
    #   or names of the attributes used to generate the slug. Defaults to :name.
    def initialize(attribute_names: :name)
      super()

      attribute_names = Array(attribute_names)

      validate_attribute_names!(attribute_names)

      @attribute_names = attribute_names.map(&:to_s)
    end

    attr_reader :attribute_names

    private

    def fetch_value(attributes, attribute_name)
      value = indifferent_fetch(attributes, attribute_name)

      return '' if value.nil?

      return value if value.is_a?(String)

      error =
        Cuprum::Error
        .new(message: "Value of #{attribute_name.inspect} must be a String")
      step { failure(error) }
    end

    def indifferent_fetch(attributes, attribute_name)
      attributes.fetch(attribute_name) do
        attributes.fetch(attribute_name.intern, '')
      end
    end

    def process(attributes:)
      validate_attributes!(attributes)

      slugify_attributes(attributes)
        .reject(&:empty?)
        .join('-')
    end

    def slugify_attributes(attributes)
      attribute_names.map do |attribute_name|
        value = fetch_value(attributes, attribute_name)

        slugify_value(value)
      end
    end

    def slugify_value(value)
      value
        .strip
        .then { |str| tools.string_tools.underscore(str) }
        .split(/[\s\-_]+/)
        .join('-')
        .gsub(EXCLUDED_CHARACTERS_PATTERN, '')
    end

    def tools
      SleepingKingStudios::Tools::Toolbelt.instance
    end

    def valid_attribute_name?(attribute_name)
      return false if attribute_name.nil?

      unless attribute_name.is_a?(String) || attribute_name.is_a?(Symbol)
        return false
      end

      !attribute_name.to_s.empty?
    end

    def validate_attribute_names!(attribute_names)
      if attribute_names.empty?
        raise ArgumentError, "attribute names can't be blank"
      end

      attribute_names.each do |attribute_name|
        next if valid_attribute_name?(attribute_name)

        raise ArgumentError, "invalid attribute name #{attribute_name.inspect}"
      end
    end

    def validate_attributes!(attributes)
      return if attributes.is_a?(Hash)

      raise ArgumentError, 'attributes must be a Hash'
    end
  end
end
