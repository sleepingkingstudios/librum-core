# frozen_string_literal: true

require 'librum/core/rspec'

module Librum::Core::RSpec
  # Namespace for shared RSpec matchers.
  module Matchers
    # @param expected [String] the expected string.
    #
    # @return [Librum::Core::RSpec::Matchers::MatchSnapshotMatcher] the snapshot
    #   matcher.
    def match_snapshot(expected)
      Librum::Core::RSpec::Matchers::MatchSnapshotMatcher.new(expected)
    end
  end
end

require 'librum/core/rspec/matchers/match_snapshot_matcher'
