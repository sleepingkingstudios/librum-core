# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::DataTable::Header,
  type: :component \
do
  subject(:header) { described_class.new(**constructor_options) }

  let(:columns) do
    [
      { key: 'first_name' },
      {
        key:   'last_name',
        label: 'Surname'
      },
      { key: 'role' }
    ]
  end
  let(:constructor_options) do
    { columns: columns }
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:columns)
        .and_any_keywords
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(header) }
    let(:snapshot) do
      <<~HTML
        <thead>
          <tr>
            <th>First Name</th>

            <th>Surname</th>

            <th>Role</th>
          </tr>
        </thead>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }
  end

  describe '#columns' do
    let(:expected_class) do
      Librum::Core::View::Components::DataField::FieldDefinition
    end
    let(:expected_labels) do
      columns.map do |column|
        column.fetch(:label) { column[:key].to_s.titleize }
      end
    end

    include_examples 'should define reader',
      :columns,
      -> { an_instance_of(Array) }

    it { expect(header.columns).to all be_a expected_class }

    it { expect(header.columns.map(&:label)).to be == expected_labels }

    context 'when initialized with columns: an Array of FieldDefinitions' do
      let(:columns) do
        super().map do |column|
          Librum::Core::View::Components::DataField::FieldDefinition
            .new(**column)
        end
      end

      it { expect(header.columns).to be == columns }
    end
  end
end
