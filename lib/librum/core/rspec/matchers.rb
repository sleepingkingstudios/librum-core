# frozen_string_literal: true

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
