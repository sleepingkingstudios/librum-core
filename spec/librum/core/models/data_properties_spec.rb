# frozen_string_literal: true

require 'rails_helper'

require 'librum/core/models/data_properties'
require 'librum/core/rspec/contracts/models/data_properties_contracts'

RSpec.describe Librum::Core::Models::DataProperties do
  include Librum::Core::RSpec::Contracts::Models::DataPropertiesContracts

  anonymous_base_class = Struct.new(:data) do
    extend Librum::Core::Models::DataProperties
  end

  subject(:model) { described_class.new(attributes[:data]) }

  let(:described_class) { anonymous_base_class }
  let(:attributes)      { { data: {} } }

  include_contract 'should define data properties',
    base_class: anonymous_base_class

  context 'when the class defines data properties' do
    let(:described_class) { Spec::ExampleModel }
    let(:attributes) do
      {
        data: {
          'nuclear' => true,
          'thrust'  => '1000 kN'
        }
      }
    end

    example_class 'Spec::ExampleModel', anonymous_base_class do |klass|
      klass.data_property :nuclear, predicate: true
      klass.data_property :thrust
    end

    include_contract 'should define data property', :nuclear, predicate: true

    include_contract 'should define data property', :thrust
  end
end
