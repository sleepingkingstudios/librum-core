# frozen_string_literal: true

require 'rails_helper'

require 'support/rocket'

RSpec.describe Librum::Core::View::Components::Resources::DestroyForm,
  type: :component \
do
  subject(:form) { described_class.new(data: data, resource: resource) }

  let(:data)     { Spec::Support::Rocket.new(name: 'Imp IV', slug: 'imp-iv') }
  let(:resource) { Cuprum::Rails::Resource.new(resource_name: 'rockets') }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:data, :resource)
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(form) }
    let(:snapshot) do
      <<~HTML
        <form action="/rockets/imp-iv" accept-charset="UTF-8" method="post">
          <input type="hidden" name="_method" value="delete" autocomplete="off">

          <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

          <button type="submit" class="button is-danger">Destroy Rocket</button>
        </form>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }
  end

  describe '#data' do
    include_examples 'should define reader', :data, -> { data }
  end

  describe '#resource' do
    include_examples 'should define reader', :resource, -> { resource }
  end

  describe '#singular_resource_name' do
    include_examples 'should define reader',
      :singular_resource_name,
      -> { resource.singular_resource_name }
  end
end
