# frozen_string_literal: true

require 'rails_helper'

require 'librum/core/view/components/identity_component'

RSpec.describe Librum::Core::View::Components::IdentityComponent,
  type: :component \
do
  subject(:component) { described_class.new(contents) }

  let(:contents) { '<h1>Greetings, Programs</h1>' }

  describe '.new' do
    it { expect(described_class).to be_constructible.with(1).argument }
  end

  describe '#call' do
    let(:rendered) { render_inline(component) }

    it { expect(rendered.to_s).to be == contents }
  end

  describe '#contents' do
    include_examples 'should define reader', :contents, -> { contents }
  end
end
