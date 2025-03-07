# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Components::DataList, type: :component do
  subject(:data_list) { described_class.new(**constructor_options) }

  let(:data) do
    {
      'first_name' => 'Alan',
      'last_name'  => 'Bradley',
      'role'       => 'user'
    }
  end
  let(:fields) do
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
    { data: data, fields: fields }
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:data, :fields, :item_component)
        .and_any_keywords
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(data_list) }
    let(:snapshot) do
      <<~HTML
        <div class="block content">
          <div class="columns mb-0">
            <div class="column is-2 has-text-weight-semibold mb-1">
              First Name
            </div>

            <div class="column">
              Alan
            </div>
          </div>

          <div class="columns mb-0">
            <div class="column is-2 has-text-weight-semibold mb-1">
              Surname
            </div>

            <div class="column">
              Bradley
            </div>
          </div>

          <div class="columns mb-0">
            <div class="column is-2 has-text-weight-semibold mb-1">
              Role
            </div>

            <div class="column">
              user
            </div>
          </div>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with item_component: value' do
      include_context 'with mock component', 'item'

      let(:constructor_options) do
        super().merge(item_component: Spec::ItemComponent)
      end
      let(:snapshot) do
        <<~HTML
          <div class="block content">
            <div class="columns mb-0">
              <div class="column is-2 has-text-weight-semibold mb-1">
                First Name
              </div>

              <div class="column">
                <mock name="item" data='{"first_name" =&gt; "Alan", "last_name" =&gt; "Bradley", "role" =&gt; "user"}' field='#&lt;Field key="first_name"&gt;'></mock>
              </div>
            </div>

            <div class="columns mb-0">
              <div class="column is-2 has-text-weight-semibold mb-1">
                Surname
              </div>

              <div class="column">
                <mock name="item" data='{"first_name" =&gt; "Alan", "last_name" =&gt; "Bradley", "role" =&gt; "user"}' field='#&lt;Field key="last_name"&gt;'></mock>
              </div>
            </div>

            <div class="columns mb-0">
              <div class="column is-2 has-text-weight-semibold mb-1">
                Role
              </div>

              <div class="column">
                <mock name="item" data='{"first_name" =&gt; "Alan", "last_name" =&gt; "Bradley", "role" =&gt; "user"}' field='#&lt;Field key="role"&gt;'></mock>
              </div>
            </div>
          </div>
        HTML
      end

      before(:example) do
        data_list.fields.each do |field|
          allow(field).to receive(:inspect) do
            %(#<Field key="#{field.key}">)
          end
        end
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with options: value' do
        let(:options)             { { key: 'value' } }
        let(:constructor_options) { super().merge(options) }
        let(:snapshot) do
          <<~HTML
            <div class="block content">
              <div class="columns mb-0">
                <div class="column is-2 has-text-weight-semibold mb-1">
                  First Name
                </div>

                <div class="column">
                  <mock name="item" data='{"first_name" =&gt; "Alan", "last_name" =&gt; "Bradley", "role" =&gt; "user"}' field='#&lt;Field key="first_name"&gt;' key="value"></mock>
                </div>
              </div>

              <div class="columns mb-0">
                <div class="column is-2 has-text-weight-semibold mb-1">
                  Surname
                </div>

                <div class="column">
                  <mock name="item" data='{"first_name" =&gt; "Alan", "last_name" =&gt; "Bradley", "role" =&gt; "user"}' field='#&lt;Field key="last_name"&gt;' key="value"></mock>
                </div>
              </div>

              <div class="columns mb-0">
                <div class="column is-2 has-text-weight-semibold mb-1">
                  Role
                </div>

                <div class="column">
                  <mock name="item" data='{"first_name" =&gt; "Alan", "last_name" =&gt; "Bradley", "role" =&gt; "user"}' field='#&lt;Field key="role"&gt;' key="value"></mock>
                </div>
              </div>
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end
  end

  describe '#data' do
    include_examples 'should define reader', :data, -> { data }
  end

  describe '#fields' do
    let(:field_class) do
      Librum::Core::View::Components::DataField::FieldDefinition
    end
    let(:expected_labels) do
      fields.map { |field| field.fetch(:label) { field[:key].to_s.titleize } }
    end

    include_examples 'should define reader',
      :fields,
      -> { an_instance_of(Array) }

    it { expect(data_list.fields).to all be_a(field_class) }

    it { expect(data_list.fields.map(&:key)).to be == fields.pluck(:key) }

    it { expect(data_list.fields.map(&:label)).to be == expected_labels }

    context 'when initialized with fields: an Array of FieldDefinitions' do
      let(:fields) do
        super().map do |field|
          Librum::Core::View::Components::DataField::FieldDefinition
            .new(**field)
        end
      end

      it { expect(data_list.fields).to be == fields }
    end
  end

  describe '#item_component' do
    include_examples 'should define reader',
      :item_component,
      Librum::Core::View::Components::DataField

    context 'when initialized with item_component: value' do
      include_context 'with mock component', 'item'

      let(:constructor_options) do
        super().merge(item_component: Spec::ItemComponent)
      end

      it { expect(data_list.item_component).to be Spec::ItemComponent }
    end
  end

  describe '#options' do
    include_examples 'should define reader', :options, {}

    context 'when initialized with options: value' do
      let(:options)             { { key: 'value' } }
      let(:constructor_options) { super().merge(options) }

      it { expect(data_list.options).to be == options }
    end
  end
end
