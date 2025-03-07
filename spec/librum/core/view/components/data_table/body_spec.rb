# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::DataTable::Body,
  type: :component \
do
  subject(:body) { described_class.new(**constructor_options) }

  shared_context 'when initialized with data' do
    let(:data) do
      [
        {
          'first_name' => 'Alan',
          'last_name'  => 'Bradley',
          'role'       => 'user'
        },
        {
          'first_name' => 'Kevin',
          'last_name'  => 'Flynn',
          'role'       => 'user'
        },
        {
          'first_name' => 'Ed',
          'last_name'  => 'Dillinger',
          'role'       => 'admin'
        }
      ]
    end
  end

  let(:columns) do
    [
      { key: 'first_name' },
      { key: 'last_name' },
      { key: 'role' }
    ]
  end
  let(:data) { [] }
  let(:constructor_options) do
    {
      columns: columns,
      data:    data
    }
  end

  describe '.new' do
    let(:expected_keywords) do
      %i[
        columns
        data
        empty_message
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

  describe '#call' do
    let(:rendered) { render_inline(body) }
    let(:snapshot) do
      <<~HTML
        <tbody>
          <tr>
            <td colspan="3">There are no matching items.</td>
          </tr>
        </tbody>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with data' do
      include_context 'when initialized with data'

      let(:snapshot) do
        <<~HTML
          <tbody>
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

            <tr>
              <td>
                Kevin
              </td>

              <td>
                Flynn
              </td>

              <td>
                user
              </td>
            </tr>

            <tr>
              <td>
                Ed
              </td>

              <td>
                Dillinger
              </td>

              <td>
                admin
              </td>
            </tr>
          </tbody>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with cell_component: value' do
      include_context 'when initialized with data'
      include_context 'with mock component', 'cell'

      let(:constructor_options) do
        super().merge(cell_component: cell_component)
      end
      let(:snapshot) do
        <<~HTML
          <tbody>
            <tr>
              <td>
                <mock name="cell" field='{key: "first_name"}' data='{"first_name" =&gt; "Alan", "last_name" =&gt; "Bradley", "role" =&gt; "user"}'></mock>
              </td>

              <td>
                <mock name="cell" field='{key: "last_name"}' data='{"first_name" =&gt; "Alan", "last_name" =&gt; "Bradley", "role" =&gt; "user"}'></mock>
              </td>

              <td>
                <mock name="cell" field='{key: "role"}' data='{"first_name" =&gt; "Alan", "last_name" =&gt; "Bradley", "role" =&gt; "user"}'></mock>
              </td>
            </tr>

            <tr>
              <td>
                <mock name="cell" field='{key: "first_name"}' data='{"first_name" =&gt; "Kevin", "last_name" =&gt; "Flynn", "role" =&gt; "user"}'></mock>
              </td>

              <td>
                <mock name="cell" field='{key: "last_name"}' data='{"first_name" =&gt; "Kevin", "last_name" =&gt; "Flynn", "role" =&gt; "user"}'></mock>
              </td>

              <td>
                <mock name="cell" field='{key: "role"}' data='{"first_name" =&gt; "Kevin", "last_name" =&gt; "Flynn", "role" =&gt; "user"}'></mock>
              </td>
            </tr>

            <tr>
              <td>
                <mock name="cell" field='{key: "first_name"}' data='{"first_name" =&gt; "Ed", "last_name" =&gt; "Dillinger", "role" =&gt; "admin"}'></mock>
              </td>

              <td>
                <mock name="cell" field='{key: "last_name"}' data='{"first_name" =&gt; "Ed", "last_name" =&gt; "Dillinger", "role" =&gt; "admin"}'></mock>
              </td>

              <td>
                <mock name="cell" field='{key: "role"}' data='{"first_name" =&gt; "Ed", "last_name" =&gt; "Dillinger", "role" =&gt; "admin"}'></mock>
              </td>
            </tr>
          </tbody>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with options: value' do
        let(:options)             { { option: 'value' } }
        let(:constructor_options) { super().merge(options) }
        let(:snapshot) do
          <<~HTML
            <tbody>
              <tr>
                <td>
                  <mock name="cell" field='{key: "first_name"}' data='{"first_name" =&gt; "Alan", "last_name" =&gt; "Bradley", "role" =&gt; "user"}' option="value"></mock>
                </td>

                <td>
                  <mock name="cell" field='{key: "last_name"}' data='{"first_name" =&gt; "Alan", "last_name" =&gt; "Bradley", "role" =&gt; "user"}' option="value"></mock>
                </td>

                <td>
                  <mock name="cell" field='{key: "role"}' data='{"first_name" =&gt; "Alan", "last_name" =&gt; "Bradley", "role" =&gt; "user"}' option="value"></mock>
                </td>
              </tr>

              <tr>
                <td>
                  <mock name="cell" field='{key: "first_name"}' data='{"first_name" =&gt; "Kevin", "last_name" =&gt; "Flynn", "role" =&gt; "user"}' option="value"></mock>
                </td>

                <td>
                  <mock name="cell" field='{key: "last_name"}' data='{"first_name" =&gt; "Kevin", "last_name" =&gt; "Flynn", "role" =&gt; "user"}' option="value"></mock>
                </td>

                <td>
                  <mock name="cell" field='{key: "role"}' data='{"first_name" =&gt; "Kevin", "last_name" =&gt; "Flynn", "role" =&gt; "user"}' option="value"></mock>
                </td>
              </tr>

              <tr>
                <td>
                  <mock name="cell" field='{key: "first_name"}' data='{"first_name" =&gt; "Ed", "last_name" =&gt; "Dillinger", "role" =&gt; "admin"}' option="value"></mock>
                </td>

                <td>
                  <mock name="cell" field='{key: "last_name"}' data='{"first_name" =&gt; "Ed", "last_name" =&gt; "Dillinger", "role" =&gt; "admin"}' option="value"></mock>
                </td>

                <td>
                  <mock name="cell" field='{key: "role"}' data='{"first_name" =&gt; "Ed", "last_name" =&gt; "Dillinger", "role" =&gt; "admin"}' option="value"></mock>
                </td>
              </tr>
            </tbody>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with empty_message: a String' do
      let(:empty_message)       { 'Something went wrong.' }
      let(:constructor_options) { super().merge(empty_message: empty_message) }
      let(:snapshot) do
        <<~HTML
          <tbody>
            <tr>
              <td colspan="3">Something went wrong.</td>
            </tr>
          </tbody>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with empty_message: a ViewComponent' do
      include_context 'with mock component', 'empty_message'

      let(:constructor_options) do
        super().merge(empty_message: Spec::EmptyMessageComponent.new)
      end
      let(:snapshot) do
        <<~HTML
          <tbody>
            <mock name="empty_message"></mock>
          </tbody>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with row_component: value' do
      include_context 'when initialized with data'
      include_context 'with mock component', 'row'

      let(:constructor_options) do
        super().merge(row_component: Spec::RowComponent)
      end
      let(:snapshot) do
        <<~HTML
          <tbody>
            <mock name="row" cell_component="Librum::Core::View::Components::DataField" columns='[{key: "first_name"}, {key: "last_name"}, {key: "role"}]' data='{"first_name" =&gt; "Alan", "last_name" =&gt; "Bradley", "role" =&gt; "user"}'></mock>

            <mock name="row" cell_component="Librum::Core::View::Components::DataField" columns='[{key: "first_name"}, {key: "last_name"}, {key: "role"}]' data='{"first_name" =&gt; "Kevin", "last_name" =&gt; "Flynn", "role" =&gt; "user"}'></mock>

            <mock name="row" cell_component="Librum::Core::View::Components::DataField" columns='[{key: "first_name"}, {key: "last_name"}, {key: "role"}]' data='{"first_name" =&gt; "Ed", "last_name" =&gt; "Dillinger", "role" =&gt; "admin"}'></mock>
          </tbody>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with options: value' do
        let(:options)             { { option: 'value' } }
        let(:constructor_options) { super().merge(options) }
        let(:snapshot) do
          <<~HTML
            <tbody>
              <mock name="row" cell_component="Librum::Core::View::Components::DataField" columns='[{key: "first_name"}, {key: "last_name"}, {key: "role"}]' data='{"first_name" =&gt; "Alan", "last_name" =&gt; "Bradley", "role" =&gt; "user"}' option="value"></mock>

              <mock name="row" cell_component="Librum::Core::View::Components::DataField" columns='[{key: "first_name"}, {key: "last_name"}, {key: "role"}]' data='{"first_name" =&gt; "Kevin", "last_name" =&gt; "Flynn", "role" =&gt; "user"}' option="value"></mock>

              <mock name="row" cell_component="Librum::Core::View::Components::DataField" columns='[{key: "first_name"}, {key: "last_name"}, {key: "role"}]' data='{"first_name" =&gt; "Ed", "last_name" =&gt; "Dillinger", "role" =&gt; "admin"}' option="value"></mock>
            </tbody>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end
  end

  describe '#cell_component' do
    include_examples 'should define reader',
      :cell_component,
      Librum::Core::View::Components::DataField

    context 'when initialized with cell_component: value' do
      include_context 'with mock component', 'cell'

      let(:constructor_options) do
        super().merge(cell_component: Spec::CellComponent)
      end

      it { expect(body.cell_component).to be Spec::CellComponent }
    end
  end

  describe '#columns' do
    include_examples 'should define reader', :columns, -> { columns }
  end

  describe '#data' do
    include_examples 'should define reader', :data, -> { data }

    wrap_context 'when initialized with data' do
      it { expect(body.data).to be == data }
    end
  end

  describe '#empty_message' do
    let(:expected) { 'There are no matching items.' }

    include_examples 'should define reader', :empty_message, -> { expected }

    context 'when initialized with empty_message: value' do
      let(:empty_message)       { 'Something went wrong.' }
      let(:constructor_options) { super().merge(empty_message: empty_message) }

      it { expect(body.empty_message).to be == empty_message }
    end
  end

  describe '#options' do
    include_examples 'should define reader', :options, {}

    context 'when initialized with options: value' do
      let(:options)             { { option: 'value' } }
      let(:constructor_options) { super().merge(options) }

      it { expect(body.options).to be == options }
    end
  end

  describe '#row_component' do
    include_examples 'should define reader',
      :row_component,
      Librum::Core::View::Components::DataTable::Row

    context 'when initialized with row_component: value' do
      include_context 'with mock component', 'row'

      let(:constructor_options) do
        super().merge(row_component: Spec::RowComponent)
      end

      it { expect(body.row_component).to be Spec::RowComponent }
    end
  end
end
