# frozen_string_literal: true

require 'librum/core/rspec/matchers'

RSpec.describe Librum::Core::RSpec::Matchers do
  include Librum::Core::RSpec::Matchers # rubocop:disable RSpec/DescribedClass

  let(:example_group) { self }

  describe '#match_snapshot' do
    let(:expected) { '<h1>Greetings, Programs</h1>' }
    let(:matcher)  { example_group.match_snapshot(expected) }
    let(:matcher_class) do
      Librum::Core::RSpec::Matchers::MatchSnapshotMatcher
    end

    it { expect(example_group).to respond_to(:match_snapshot).with(1).argument }

    it { expect(matcher).to be_a matcher_class }

    it { expect(matcher.expected).to be == expected }
  end
end
