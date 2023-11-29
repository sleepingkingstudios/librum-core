# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::Resources::ViewResource do
  subject(:resource) { described_class.new(**constructor_options) }

  let(:constructor_options) { { name: 'rockets' } }

  describe '.new' do
    let(:expected_keywords) do
      %i[
        block_component
        collection
        entity_class
        form_component
        name
        qualified_name
        routes
        singular
        singular_name
        table_component
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

  describe '#block_component' do
    include_examples 'should define reader', :block_component, nil

    context 'when initialized with a block component' do
      let(:block_component) { Object.new.freeze }
      let(:constructor_options) do
        super().merge(block_component: block_component)
      end

      it { expect(resource.block_component).to be block_component }
    end
  end

  describe '#form_component' do
    include_examples 'should define reader', :form_component, nil

    context 'when initialized with a block component' do
      let(:form_component) { Object.new.freeze }
      let(:constructor_options) do
        super().merge(form_component: form_component)
      end

      it { expect(resource.form_component).to be form_component }
    end
  end

  describe '#table_component' do
    include_examples 'should define reader', :table_component, nil

    context 'when initialized with a block component' do
      let(:table_component) { Object.new.freeze }
      let(:constructor_options) do
        super().merge(table_component: table_component)
      end

      it { expect(resource.table_component).to be table_component }
    end
  end
end
