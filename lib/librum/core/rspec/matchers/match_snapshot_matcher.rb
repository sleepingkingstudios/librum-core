# frozen_string_literal: true

require 'diffy'

require 'librum/core/rspec/matchers'
require 'librum/core/rspec/utils/pretty_render'

module Librum::Core::RSpec::Matchers
  # Matcher asserting the string or document matches the expected value.
  class MatchSnapshotMatcher
    # @param expected [String] the expected string.
    def initialize(expected)
      @expected = expected
    end

    # @param [Object] the actual object.
    attr_reader :actual

    # @param [String] the expected string.
    attr_reader :expected

    # @return [String] the description of the matcher.
    def description
      'match the snapshot'
    end

    # @param actual [Object] the object to match.
    #
    # @return [true, false] false if the object matches the expected snapshot,
    #   otherwise true.
    def does_not_match?(actual)
      @actual   = actual
      @diffable = document? ? pretty_render(actual) : actual.to_s

      diffable != expected
    end

    # @return [String] the message to display on failure.
    def failure_message
      "expected the #{inspect_actual} to #{description}:\n\n" + generate_diff
    end

    # @return [String] the message to display on failure for a negated matcher.
    def failure_message_when_negated
      "expected the #{inspect_actual} not to #{description}"
    end

    # @param actual [Object] the object to match.
    #
    # @return [true, false] true if the object matches the expected snapshot,
    #   otherwise false.
    def matches?(actual)
      @actual   = actual
      @diffable = document? ? pretty_render(actual) : actual.to_s

      diffable == expected
    end

    private

    attr_reader :diffable

    def document?
      actual.is_a?(Nokogiri::XML::Node)
    end

    def generate_diff
      Diffy::Diff.new(expected, diffable).to_s(:color)
    end

    def inspect_actual
      return 'document' if document?

      return 'string' if string?

      'object'
    end

    def pretty_render(document)
      Librum::Core::RSpec::Utils::PrettyRender.new.call(document)
    end

    def string?
      actual.is_a?(String)
    end
  end
end
