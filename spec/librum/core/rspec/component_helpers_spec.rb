# frozen_string_literal: true

require 'rails_helper'

require 'librum/core/rspec/component_helpers'

RSpec.describe Librum::Core::RSpec::ComponentHelpers do
  subject(:example_group) { described_class.new }

  let(:described_class) { Spec::ExampleGroup }

  example_class 'Spec::ExampleGroup' do |klass|
    klass.include Librum::Core::RSpec::ComponentHelpers # rubocop:disable RSpec/DescribedClass
  end

  it { expect(described_class).to be < Librum::Core::RSpec::Matchers }

  it { expect(described_class).to be < ViewComponent::TestHelpers }

  describe '#pretty_render' do
    let(:mock_renderer) do
      instance_double(
        Librum::Core::RSpec::Utils::PrettyRender,
        call: '(pretty)'
      )
    end
    let(:value) { '<h1>Greetings, Programs</h1>' }

    before(:example) do
      allow(Librum::Core::RSpec::Utils::PrettyRender)
        .to receive(:new)
        .and_return(mock_renderer)
    end

    it { expect(example_group).to respond_to(:pretty_render).with(1).argument }

    it { expect(example_group.pretty_render(value)).to be == '(pretty)' }
  end
end
