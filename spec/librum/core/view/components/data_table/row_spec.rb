# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::DataTable::Row,
  type: :component \
do
  subject(:row) { described_class.new(**constructor_options) }

  let(:columns) do
    [
      { key: 'first_name' },
      { key: 'last_name' },
      { key: 'role' }
    ]
  end
  let(:data) do
    {
      'first_name' => 'Alan',
      'last_name'  => 'Bradley',
      'role'       => 'user'
    }
  end
  let(:constructor_options) do
    {
      columns: columns,
      data:    data
    }
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:columns, :data)
        .and_any_keywords
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(row) }
    let(:snapshot) do
      <<~HTML
        <tr>
          <td>
            Alan
          </td>

          <td>
            Bradley
          </td>

          <td>
            user
          </td>
        </tr>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with cell_component: value' do
      include_context 'with mock component', 'cell'

      let(:constructor_options) do
        super().merge(cell_component: Spec::CellComponent)
      end
      let(:snapshot) do
        <<~HTML
          <tr>
            <td>
              <mock name="cell" field='{:key=&gt;"first_name"}' data='{"first_name"=&gt;"Alan", "last_name"=&gt;"Bradley", "role"=&gt;"user"}'></mock>
            </td>

            <td>
              <mock name="cell" field='{:key=&gt;"last_name"}' data='{"first_name"=&gt;"Alan", "last_name"=&gt;"Bradley", "role"=&gt;"user"}'></mock>
            </td>

            <td>
              <mock name="cell" field='{:key=&gt;"role"}' data='{"first_name"=&gt;"Alan", "last_name"=&gt;"Bradley", "role"=&gt;"user"}'></mock>
            </td>
          </tr>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with options: value' do
        let(:options)             { { option: 'value' } }
        let(:constructor_options) { super().merge(options) }
        let(:snapshot) do
          <<~HTML
            <tr>
              <td>
                <mock name="cell" field='{:key=&gt;"first_name"}' data='{"first_name"=&gt;"Alan", "last_name"=&gt;"Bradley", "role"=&gt;"user"}' option="value"></mock>
              </td>

              <td>
                <mock name="cell" field='{:key=&gt;"last_name"}' data='{"first_name"=&gt;"Alan", "last_name"=&gt;"Bradley", "role"=&gt;"user"}' option="value"></mock>
              </td>

              <td>
                <mock name="cell" field='{:key=&gt;"role"}' data='{"first_name"=&gt;"Alan", "last_name"=&gt;"Bradley", "role"=&gt;"user"}' option="value"></mock>
              </td>
            </tr>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end
  end

  describe '#cell_component' do
    let(:expected) { Librum::Core::View::Components::DataField }

    include_examples 'should define reader', :cell_component, -> { expected }

    context 'when initialized with cell_component: value' do
      include_context 'with mock component', 'cell'

      let(:constructor_options) do
        super().merge(cell_component: Spec::CellComponent)
      end

      it { expect(row.cell_component).to be Spec::CellComponent }
    end
  end

  describe '#columns' do
    include_examples 'should define reader', :columns, -> { columns }
  end

  describe '#data' do
    include_examples 'should define reader', :data, -> { data }
  end

  describe '#options' do
    include_examples 'should define reader', :options, {}

    context 'when initialized with options: value' do
      let(:options)             { { option: 'value' } }
      let(:constructor_options) { super().merge(options) }

      it { expect(row.options).to be == options }
    end
  end
end
