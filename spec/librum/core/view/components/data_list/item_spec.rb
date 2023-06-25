# frozen_string_literal: true

require 'rails_helper'

require 'librum/core/view/components/data_list/item'
require 'librum/core/view/components/mock_component'

RSpec.describe Librum::Core::View::Components::DataList::Item,
  type: :component \
do
  subject(:list_item) do
    described_class.new(
      data:  data,
      field: field
    )
  end

  let(:data)  { Struct.new(:name).new('Alan Bradley') }
  let(:field) { { key: 'name' } }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:data, :field)
        .and_any_keywords
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(list_item) }
    let(:snapshot) do
      <<~HTML
        <p>
          Alan Bradley
        </p>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with field: { default: a ViewComponent }' do
      let(:data)    { Struct.new(:name).new('') }
      let(:default) { ->(*) { Spec::DefaultComponent.new } }
      let(:field)   { super().merge(default: default) }
      let(:snapshot) do
        <<~HTML
          <mock name="custom_component"></mock>
        HTML
      end

      example_class 'Spec::DefaultComponent',
        Librum::Core::View::Components::MockComponent \
      do |klass|
        klass.define_method(:initialize) do |**options|
          super('custom_component', **options)
        end
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with field: { value: a ViewComponent }' do
      let(:value) { Spec::CustomComponent.new }
      let(:field) { super().merge(value: value) }
      let(:snapshot) do
        <<~HTML
          <mock name="custom_component"></mock>
        HTML
      end

      example_class 'Spec::CustomComponent',
        Librum::Core::View::Components::MockComponent \
      do |klass|
        klass.define_method(:initialize) do |**options|
          super('custom_component', **options)
        end
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end
end
