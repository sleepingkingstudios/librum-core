# frozen_string_literal: true

require 'rspec/sleeping_king_studios/contract'

require 'librum/core/rspec/contracts/responders'

module Librum::Core::RSpec::Contracts::Responders
  module JsonContracts
    # Contract asserting the action responds with JSON.
    module ShouldRespondWithJsonContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |http_status, &block|
        let(:response) { responder.call(result) }
        let(:configured_data) do
          instance_exec(&block)
        end

        it { expect(response).to be_a Cuprum::Rails::Responses::JsonResponse }

        it { expect(response.status).to be http_status }

        it { expect(response.data).to deep_match(configured_data) }
      end
    end
  end
end
