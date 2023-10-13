# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::ClassName do
  include Librum::Core::RSpec::Contracts::ComponentContracts

  subject(:component) { described_class.new(**options) }

  let(:described_class) { Spec::ExampleComponent }
  let(:options)         { {} }

  example_class 'Spec::ExampleComponent', ViewComponent::Base do |klass|
    klass.include Librum::Core::View::ClassName # rubocop:disable RSpec/DescribedClass
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:class_name)
        .and_any_keywords
    end
  end

  include_contract 'should define options'

  include_contract 'should define class name option'
end
