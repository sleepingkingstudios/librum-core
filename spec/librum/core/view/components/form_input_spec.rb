# frozen_string_literal: true

require 'rails_helper'

require 'stannum/errors'

RSpec.describe Librum::Core::View::Components::FormInput, type: :component do
  subject(:input) { described_class.new(name, **options) }

  let(:name)     { 'username' }
  let(:options)  { {} }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(1).argument
        .and_keywords(:errors, :id, :placeholder, :type, :value)
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

    describe 'with placeholder: value' do
      let(:placeholder) { 'Enter Username' }
      let(:options)     { super().merge(placeholder: placeholder) }
      let(:snapshot) do
        <<~HTML
          <input name="username" class="input" placeholder="Enter Username" type="text">
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

    describe 'with value: a String' do
      let(:value)   { 'Alan Bradley' }
      let(:options) { super().merge(value: value) }
      let(:snapshot) do
        <<~HTML
          <input name="username" class="input" type="text" value="Alan Bradley">
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

    context 'when initialized with id: value' do
      let(:id)      { 'username' }
      let(:options) { super().merge(id: id) }

      it { expect(input.id).to be == id }
    end
  end

  describe '#name' do
    include_examples 'should define reader', :name, -> { name }
  end

  describe '#placeholder' do
    include_examples 'should define reader', :placeholder, nil

    context 'when initialized with placeholder: value' do
      let(:placeholder) { 'Enter Username' }
      let(:options)     { super().merge(placeholder: placeholder) }

      it { expect(input.placeholder).to be == placeholder }
    end
  end

  describe '#type' do
    include_examples 'should define reader', :type, 'text'

    context 'when initialized with type: value' do
      let(:type)    { 'email' }
      let(:options) { super().merge(type: type) }

      it { expect(input.type).to be == type }
    end
  end

  describe '#value' do
    include_examples 'should define reader', :value, nil

    context 'when initialized with value: a String' do
      let(:value)   { 'Alan Bradley' }
      let(:options) { super().merge(value: value) }

      it { expect(input.value).to be == value }
    end
  end
end
