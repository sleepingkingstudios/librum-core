# frozen_string_literal: true

require 'rails_helper'

require 'stannum/errors'

require 'librum/core/view/components/form_input'

RSpec.describe Librum::Core::View::Components::FormInput, type: :component do
  subject(:input) { described_class.new(name, **options) }

  let(:name)     { 'username' }
  let(:options)  { {} }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(1).argument
        .and_keywords(:errors, :id, :type)
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(input) }
    let(:snapshot) do
      <<~HTML
        <input name="username" class="input" type="text">
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with errors: an empty Array' do
      let(:errors)  { [] }
      let(:options) { super().merge(errors: errors) }

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with errors: a non-empty Array' do
      let(:errors)  { ["can't be blank"] }
      let(:options) { super().merge(errors: errors) }
      let(:snapshot) do
        <<~HTML
          <input name="username" class="input is-danger" type="text">
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with id: value' do
      let(:name)    { 'user[username]' }
      let(:id)      { 'user_username' }
      let(:options) { super().merge(id: id) }
      let(:snapshot) do
        <<~HTML
          <input id="user_username" name="user[username]" class="input" type="text">
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with type: value' do
      let(:type)    { 'email' }
      let(:options) { super().merge(type: type) }
      let(:snapshot) do
        <<~HTML
          <input name="username" class="input" type="email">
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#errors' do
    include_examples 'should define reader', :errors, nil

    context 'when initialized with errors: value' do
      let(:errors)  { ["can't be blank"] }
      let(:options) { super().merge(errors: errors) }

      it { expect(input.errors).to be == errors }
    end
  end

  describe '#id' do
    include_examples 'should define reader', :id, nil

    context 'when initialized with type: value' do
      let(:name)    { 'user[username]' }
      let(:id)      { 'user_username' }
      let(:options) { super().merge(id: id) }

      it { expect(input.id).to be == id }
    end
  end

  describe '#name' do
    include_examples 'should define reader', :name, -> { name }
  end

  describe '#type' do
    include_examples 'should define reader', :type, 'text'

    context 'when initialized with type: value' do
      let(:type)    { 'email' }
      let(:options) { super().merge(type: type) }

      it { expect(input.type).to be == type }
    end
  end
end
