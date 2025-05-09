# frozen_string_literal: true

require 'rspec/sleeping_king_studios/contract'

module Librum::Core::RSpec::Contracts
  # :nocov:

  # Contracts for asserting on model objects.
  module ModelContracts
    include Librum::Core::RSpec::Contracts::Models::AssociationsContracts
    include Librum::Core::RSpec::Contracts::Models::AttributesContracts
    include Librum::Core::RSpec::Contracts::Models::ValidationContracts

    # Contract asserting the model has a primary key, slug, and timestamps.
    module ShouldBeAModelContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |slug: true|
        include Librum::Core::RSpec::Contracts::ModelContracts

        include_contract 'should define primary key'

        include_contract 'should define timestamps'

        include_contract 'should define slug' if slug
      end
    end
  end
  # :nocov:
end
