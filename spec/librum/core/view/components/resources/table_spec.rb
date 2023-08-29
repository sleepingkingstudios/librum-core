# frozen_string_literal: true

require 'rails_helper'

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

    context 'with resource_name: multi-word string' do
      let(:resource) do
        Cuprum::Rails::Resource.new(resource_name: 'launch_sites')
      end
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
                <td colspan="3">There are no launch sites matching the criteria.</td>
              </tr>
            </tbody>
          </table>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#empty_message' do
    let(:expected) { 'There are no users matching the criteria.' }

    include_examples 'should define reader', :empty_message, -> { expected }

    context 'when initialized with resource_name: multi-word string' do
      let(:resource) do
        Cuprum::Rails::Resource.new(resource_name: 'launch_sites')
      end
      let(:expected) { 'There are no launch sites matching the criteria.' }

      it { expect(table.empty_message).to be == expected }
    end
  end
end
