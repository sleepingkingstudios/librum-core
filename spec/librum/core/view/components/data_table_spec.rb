# frozen_string_literal: true

require 'rails_helper'

require 'librum/core/view/components/data_table'

RSpec.describe Librum::Core::View::Components::DataTable, type: :component do
  subject(:table) { described_class.new(**constructor_options) }

  shared_context 'with data' do
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
      {
        key:   'last_name',
        label: 'Surname'
      },
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
        class_names
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

  describe '#body_component' do
    include_examples 'should define reader',
      :body_component,
      described_class::Body

    context 'when initialized with body_component: value' do
      include_context 'with mock component', 'body'

      let(:constructor_options) do
        super().merge(body_component: Spec::BodyComponent)
      end

      it { expect(table.body_component).to be Spec::BodyComponent }
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(table) }
    let(:snapshot) do
      <<~HTML
        <table class="table">
          <thead>
            <tr>
              <th>First Name</th>

              <th>Surname</th>

              <th>Role</th>
            </tr>
          </thead>

          <tbody>
            <tr>
              <td colspan="3">There are no matching items.</td>
            </tr>
          </tbody>
        </table>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    wrap_context 'with data' do
      let(:snapshot) do
        <<~HTML
          <table class="table">
            <thead>
              <tr>
                <th>First Name</th>

                <th>Surname</th>

                <th>Role</th>
              </tr>
            </thead>

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
          </table>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with body_component: value' do
      include_context 'with mock component', 'body'

      let(:constructor_options) do
        super().merge(body_component: Spec::BodyComponent)
      end
      let(:snapshot) do
        <<~HTML
          <table class="table">
            <thead>
              <tr>
                <th>First Name</th>

                <th>Surname</th>

                <th>Role</th>
              </tr>
            </thead>

            <mock name="body" cell_component="Librum::Core::View::Components::DataField" columns='[{:key=&gt;"first_name"}, {:key=&gt;"last_name", :label=&gt;"Surname"}, {:key=&gt;"role"}]' data="[]" empty_message="nil" row_component="Librum::Core::View::Components::DataTable::Row"></mock>
          </table>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with options' do
        let(:options)             { { option: 'value' } }
        let(:constructor_options) { super().merge(options) }
        let(:snapshot) do
          <<~HTML
            <table class="table">
              <thead>
                <tr>
                  <th>First Name</th>

                  <th>Surname</th>

                  <th>Role</th>
                </tr>
              </thead>

              <mock name="body" cell_component="Librum::Core::View::Components::DataField" columns='[{:key=&gt;"first_name"}, {:key=&gt;"last_name", :label=&gt;"Surname"}, {:key=&gt;"role"}]' data="[]" empty_message="nil" row_component="Librum::Core::View::Components::DataTable::Row" option="value"></mock>
            </table>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with cell_component: value' do
      include_context 'with data'
      include_context 'with mock component', 'cell'

      let(:constructor_options) do
        super().merge(cell_component: Spec::CellComponent)
      end
      let(:snapshot) do
        <<~HTML
          <table class="table">
            <thead>
              <tr>
                <th>First Name</th>

                <th>Surname</th>

                <th>Role</th>
              </tr>
            </thead>

            <tbody>
              <tr>
                <td>
                  <mock name="cell" field='{:key=&gt;"first_name"}' data='{"first_name"=&gt;"Alan", "last_name"=&gt;"Bradley", "role"=&gt;"user"}'></mock>
                </td>

                <td>
                  <mock name="cell" field='{:key=&gt;"last_name", :label=&gt;"Surname"}' data='{"first_name"=&gt;"Alan", "last_name"=&gt;"Bradley", "role"=&gt;"user"}'></mock>
                </td>

                <td>
                  <mock name="cell" field='{:key=&gt;"role"}' data='{"first_name"=&gt;"Alan", "last_name"=&gt;"Bradley", "role"=&gt;"user"}'></mock>
                </td>
              </tr>

              <tr>
                <td>
                  <mock name="cell" field='{:key=&gt;"first_name"}' data='{"first_name"=&gt;"Kevin", "last_name"=&gt;"Flynn", "role"=&gt;"user"}'></mock>
                </td>

                <td>
                  <mock name="cell" field='{:key=&gt;"last_name", :label=&gt;"Surname"}' data='{"first_name"=&gt;"Kevin", "last_name"=&gt;"Flynn", "role"=&gt;"user"}'></mock>
                </td>

                <td>
                  <mock name="cell" field='{:key=&gt;"role"}' data='{"first_name"=&gt;"Kevin", "last_name"=&gt;"Flynn", "role"=&gt;"user"}'></mock>
                </td>
              </tr>

              <tr>
                <td>
                  <mock name="cell" field='{:key=&gt;"first_name"}' data='{"first_name"=&gt;"Ed", "last_name"=&gt;"Dillinger", "role"=&gt;"admin"}'></mock>
                </td>

                <td>
                  <mock name="cell" field='{:key=&gt;"last_name", :label=&gt;"Surname"}' data='{"first_name"=&gt;"Ed", "last_name"=&gt;"Dillinger", "role"=&gt;"admin"}'></mock>
                </td>

                <td>
                  <mock name="cell" field='{:key=&gt;"role"}' data='{"first_name"=&gt;"Ed", "last_name"=&gt;"Dillinger", "role"=&gt;"admin"}'></mock>
                </td>
              </tr>
            </tbody>
          </table>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with options' do
        let(:options)             { { option: 'value' } }
        let(:constructor_options) { super().merge(options) }
        let(:snapshot) do
          <<~HTML
            <table class="table">
              <thead>
                <tr>
                  <th>First Name</th>

                  <th>Surname</th>

                  <th>Role</th>
                </tr>
              </thead>

              <tbody>
                <tr>
                  <td>
                    <mock name="cell" field='{:key=&gt;"first_name"}' data='{"first_name"=&gt;"Alan", "last_name"=&gt;"Bradley", "role"=&gt;"user"}' option="value"></mock>
                  </td>

                  <td>
                    <mock name="cell" field='{:key=&gt;"last_name", :label=&gt;"Surname"}' data='{"first_name"=&gt;"Alan", "last_name"=&gt;"Bradley", "role"=&gt;"user"}' option="value"></mock>
                  </td>

                  <td>
                    <mock name="cell" field='{:key=&gt;"role"}' data='{"first_name"=&gt;"Alan", "last_name"=&gt;"Bradley", "role"=&gt;"user"}' option="value"></mock>
                  </td>
                </tr>

                <tr>
                  <td>
                    <mock name="cell" field='{:key=&gt;"first_name"}' data='{"first_name"=&gt;"Kevin", "last_name"=&gt;"Flynn", "role"=&gt;"user"}' option="value"></mock>
                  </td>

                  <td>
                    <mock name="cell" field='{:key=&gt;"last_name", :label=&gt;"Surname"}' data='{"first_name"=&gt;"Kevin", "last_name"=&gt;"Flynn", "role"=&gt;"user"}' option="value"></mock>
                  </td>

                  <td>
                    <mock name="cell" field='{:key=&gt;"role"}' data='{"first_name"=&gt;"Kevin", "last_name"=&gt;"Flynn", "role"=&gt;"user"}' option="value"></mock>
                  </td>
                </tr>

                <tr>
                  <td>
                    <mock name="cell" field='{:key=&gt;"first_name"}' data='{"first_name"=&gt;"Ed", "last_name"=&gt;"Dillinger", "role"=&gt;"admin"}' option="value"></mock>
                  </td>

                  <td>
                    <mock name="cell" field='{:key=&gt;"last_name", :label=&gt;"Surname"}' data='{"first_name"=&gt;"Ed", "last_name"=&gt;"Dillinger", "role"=&gt;"admin"}' option="value"></mock>
                  </td>

                  <td>
                    <mock name="cell" field='{:key=&gt;"role"}' data='{"first_name"=&gt;"Ed", "last_name"=&gt;"Dillinger", "role"=&gt;"admin"}' option="value"></mock>
                  </td>
                </tr>
              </tbody>
            </table>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with empty_message: value' do
      let(:empty_message)       { 'Something went wrong.' }
      let(:constructor_options) { super().merge(empty_message: empty_message) }
      let(:snapshot) do
        <<~HTML
          <table class="table">
            <thead>
              <tr>
                <th>First Name</th>

                <th>Surname</th>

                <th>Role</th>
              </tr>
            </thead>

            <tbody>
              <tr>
                <td colspan="3">Something went wrong.</td>
              </tr>
            </tbody>
          </table>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with footer_component: value' do
      include_context 'with mock component', 'footer'

      let(:constructor_options) do
        super().merge(footer_component: Spec::FooterComponent)
      end
      let(:snapshot) do
        <<~HTML
          <table class="table">
            <thead>
              <tr>
                <th>First Name</th>

                <th>Surname</th>

                <th>Role</th>
              </tr>
            </thead>

            <tbody>
              <tr>
                <td colspan="3">There are no matching items.</td>
              </tr>
            </tbody>

            <mock name="footer"></mock>
          </table>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with options' do
        let(:options)             { { option: 'value' } }
        let(:constructor_options) { super().merge(options) }
        let(:snapshot) do
          <<~HTML
            <table class="table">
              <thead>
                <tr>
                  <th>First Name</th>

                  <th>Surname</th>

                  <th>Role</th>
                </tr>
              </thead>

              <tbody>
                <tr>
                  <td colspan="3">There are no matching items.</td>
                </tr>
              </tbody>

              <mock name="footer" option="value"></mock>
            </table>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with header_component: value' do
      include_context 'with mock component', 'header'

      let(:constructor_options) do
        super().merge(header_component: Spec::HeaderComponent)
      end
      let(:snapshot) do
        <<~HTML
          <table class="table">
            <mock name="header" columns='[{:key=&gt;"first_name"}, {:key=&gt;"last_name", :label=&gt;"Surname"}, {:key=&gt;"role"}]'></mock>

            <tbody>
              <tr>
                <td colspan="3">There are no matching items.</td>
              </tr>
            </tbody>
          </table>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with options' do
        let(:options)             { { option: 'value' } }
        let(:constructor_options) { super().merge(options) }
        let(:snapshot) do
          <<~HTML
            <table class="table">
              <mock name="header" columns='[{:key=&gt;"first_name"}, {:key=&gt;"last_name", :label=&gt;"Surname"}, {:key=&gt;"role"}]' option="value"></mock>

              <tbody>
                <tr>
                  <td colspan="3">There are no matching items.</td>
                </tr>
              </tbody>
            </table>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with row_component: value' do
      include_context 'with data'
      include_context 'with mock component', 'row'

      let(:constructor_options) do
        super().merge(row_component: Spec::RowComponent)
      end
      let(:snapshot) do
        <<~HTML
          <table class="table">
            <thead>
              <tr>
                <th>First Name</th>

                <th>Surname</th>

                <th>Role</th>
              </tr>
            </thead>

            <tbody>
              <mock name="row" cell_component="Librum::Core::View::Components::DataField" columns='[{:key=&gt;"first_name"}, {:key=&gt;"last_name", :label=&gt;"Surname"}, {:key=&gt;"role"}]' data='{"first_name"=&gt;"Alan", "last_name"=&gt;"Bradley", "role"=&gt;"user"}'></mock>

              <mock name="row" cell_component="Librum::Core::View::Components::DataField" columns='[{:key=&gt;"first_name"}, {:key=&gt;"last_name", :label=&gt;"Surname"}, {:key=&gt;"role"}]' data='{"first_name"=&gt;"Kevin", "last_name"=&gt;"Flynn", "role"=&gt;"user"}'></mock>

              <mock name="row" cell_component="Librum::Core::View::Components::DataField" columns='[{:key=&gt;"first_name"}, {:key=&gt;"last_name", :label=&gt;"Surname"}, {:key=&gt;"role"}]' data='{"first_name"=&gt;"Ed", "last_name"=&gt;"Dillinger", "role"=&gt;"admin"}'></mock>
            </tbody>
          </table>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      context 'when initialized with options: value' do
        let(:options)             { { option: 'value' } }
        let(:constructor_options) { super().merge(options) }
        let(:snapshot) do
          <<~HTML
            <table class="table">
              <thead>
                <tr>
                  <th>First Name</th>

                  <th>Surname</th>

                  <th>Role</th>
                </tr>
              </thead>

              <tbody>
                <mock name="row" cell_component="Librum::Core::View::Components::DataField" columns='[{:key=&gt;"first_name"}, {:key=&gt;"last_name", :label=&gt;"Surname"}, {:key=&gt;"role"}]' data='{"first_name"=&gt;"Alan", "last_name"=&gt;"Bradley", "role"=&gt;"user"}' option="value"></mock>

                <mock name="row" cell_component="Librum::Core::View::Components::DataField" columns='[{:key=&gt;"first_name"}, {:key=&gt;"last_name", :label=&gt;"Surname"}, {:key=&gt;"role"}]' data='{"first_name"=&gt;"Kevin", "last_name"=&gt;"Flynn", "role"=&gt;"user"}' option="value"></mock>

                <mock name="row" cell_component="Librum::Core::View::Components::DataField" columns='[{:key=&gt;"first_name"}, {:key=&gt;"last_name", :label=&gt;"Surname"}, {:key=&gt;"role"}]' data='{"first_name"=&gt;"Ed", "last_name"=&gt;"Dillinger", "role"=&gt;"admin"}' option="value"></mock>
              </tbody>
            </table>
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

      it { expect(table.cell_component).to be Spec::CellComponent }
    end
  end

  describe '#columns' do
    include_examples 'should define reader', :columns, -> { columns }
  end

  describe '#data' do
    include_examples 'should define reader', :data, []

    context 'when initialized with data' do
      include_context 'with data'

      it { expect(table.data).to be == data }
    end
  end

  describe '#empty_message' do
    include_examples 'should define reader', :empty_message, nil

    context 'when initialized with empty_message: value' do
      let(:empty_message)       { 'Something went wrong.' }
      let(:constructor_options) { super().merge(empty_message: empty_message) }

      it { expect(table.empty_message).to be == empty_message }
    end
  end

  describe '#footer_component' do
    include_examples 'should define reader', :footer_component, nil

    context 'when initialized with footer_component: value' do
      include_context 'with mock component', 'footer'

      let(:constructor_options) do
        super().merge(footer_component: Spec::FooterComponent)
      end

      it { expect(table.footer_component).to be Spec::FooterComponent }
    end
  end

  describe '#header_component' do
    include_examples 'should define reader',
      :header_component,
      described_class::Header

    context 'when initialized with header_component: value' do
      include_context 'with mock component', 'header'

      let(:constructor_options) do
        super().merge(header_component: Spec::HeaderComponent)
      end

      it { expect(table.header_component).to be Spec::HeaderComponent }
    end
  end

  describe '#options' do
    include_examples 'should define reader', :options, {}

    context 'when initialized with options: value' do
      let(:options)             { { option: 'value' } }
      let(:constructor_options) { super().merge(options) }

      it { expect(table.options).to be == options }
    end
  end

  describe '#row_component' do
    include_examples 'should define reader',
      :row_component,
      described_class::Row

    context 'when initialized with row_component: value' do
      include_context 'with mock component', 'row'

      let(:constructor_options) do
        super().merge(row_component: Spec::RowComponent)
      end

      it { expect(table.row_component).to be Spec::RowComponent }
    end
  end
end
