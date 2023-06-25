# frozen_string_literal: true

require 'rails_helper'

require 'librum/core/view/components/resources/table'

RSpec.describe Librum::Core::View::Components::Resources::Table,
  type: :component \
do
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
  let(:data)     { [] }
  let(:resource) { Cuprum::Rails::Resource.new(resource_name: 'users') }
  let(:constructor_options) do
    {
      columns:  columns,
      data:     data,
      resource: resource
    }
  end

  describe '.new' do
    let(:expected_keywords) do
      %i[
        columns
        data
        resource
      ]
    end

    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(*expected_keywords)
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(table) }
    let(:snapshot) do
      <<~HTML
        <table class="table is-striped">
          <thead>
            <tr>
              <th>First Name</th>

              <th>Surname</th>

              <th>Role</th>
            </tr>
          </thead>

          <tbody>
            <tr>
              <td colspan="3">There are no users matching the criteria.</td>
            </tr>
          </tbody>
        </table>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    wrap_context 'with data' do
      let(:snapshot) do
        <<~HTML
          <table class="table is-striped">
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
  end
end
