# frozen_string_literal: true

require 'librum/core/resources/base_resource'

RSpec.describe Librum::Core::Resources::BaseResource do
  subject(:resource) { described_class.new(**constructor_options) }

  let(:constructor_options) { { resource_name: 'rockets' } }

  describe '.new' do
    let(:expected_keywords) do
      %i[
        collection
        resource_class
        resource_name
        routes
        singular
        skip_authentication
      ]
    end

    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(*expected_keywords)
        .and_any_keywords
    end
  end
end
