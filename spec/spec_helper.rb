# frozen_string_literal: true

unless ENV['COVERAGE'] == 'false'
  require 'simplecov'

  SimpleCov.start
end

require 'byebug'
require 'cuprum/rspec/be_a_result'
require 'cuprum/rspec/be_callable'
require 'rspec/sleeping_king_studios/all'

# Isolated namespace for defining spec-only or transient objects.
module Spec; end

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.include Cuprum::RSpec::Matchers
  config.extend  RSpec::SleepingKingStudios::Concerns::ExampleConstants
  config.extend  RSpec::SleepingKingStudios::Concerns::IncludeContract
  config.extend  RSpec::SleepingKingStudios::Concerns::FocusExamples
  config.extend  RSpec::SleepingKingStudios::Concerns::WrapExamples
  config.include RSpec::SleepingKingStudios::Deferred::Consumer
  config.include RSpec::SleepingKingStudios::Examples::PropertyExamples

  config.disable_monkey_patching!

  # This allows you to limit a spec run to individual examples or groups
  # you care about by tagging them with `:focus` metadata.
  config.filter_run_when_matching :focus

  # Allows RSpec to persist some state between runs.
  config.example_status_persistence_file_path = 'spec/examples.txt'

  # Print the 10 slowest examples and example groups.
  config.profile_examples = 10 if ENV['CI']

  # Run specs in random order to surface order dependencies.
  config.order = :random
  Kernel.srand config.seed

  # rspec-expectations config goes here.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  # This option will default to `:apply_to_host_groups` in RSpec 4 (and will
  # have no way to turn it off -- the option exists only for backwards
  # compatibility in RSpec 3). It causes shared context metadata to be
  # inherited by the metadata hash of host groups and examples, rather than
  # triggering implicit auto-inclusion in groups with matching metadata.
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
