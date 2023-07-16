# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::Responses::Html::RenderComponentResponse do
  subject(:response) { described_class.new(component, **options) }

  let(:component) { Object.new.freeze }
  let(:options)   { {} }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(1).argument
        .and_keywords(:assigns, :flash, :layout, :status)
    end
  end

  describe '#assigns' do
    include_examples 'should define reader', :assigns, {}

    context 'when initialized with assigns: a Hash' do
      let(:assigns) { { key: 'value' } }
      let(:options) { super().merge(assigns: assigns) }

      it { expect(response.assigns).to be == assigns }
    end
  end

  describe '#call' do
    let(:renderer_flash) do
      instance_double(
        ActionDispatch::Flash::FlashHash,
        now: instance_double(ActionDispatch::Flash::FlashNow, '[]=': nil)
      )
    end
    let(:renderer) do
      instance_double(
        ActionController::Base,
        flash:                 renderer_flash,
        instance_variable_set: nil,
        render:                nil
      )
    end
    let(:expected) { {} }

    it { expect(response).to respond_to(:call).with(1).argument }

    it 'should render the component' do
      response.call(renderer)

      expect(renderer).to have_received(:render).with(component, **expected)
    end

    context 'when initialized with assigns: value' do
      let(:assigns) do
        {
          page:    { title: 'Custom Title' },
          session: { token: '12345' }
        }
      end
      let(:options) { super().merge(assigns: assigns) }

      it 'should assign the variables', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
        response.call(renderer)

        assigns.each do |key, value|
          expect(renderer)
            .to have_received(:instance_variable_set)
            .with("@#{key}", value)
        end
      end

      it 'should render the component' do
        response.call(renderer)

        expect(renderer).to have_received(:render).with(component, **expected)
      end
    end

    context 'when initialized with flash: a Hash' do
      let(:flash) do
        {
          alert:  'Reactor temperature critical',
          notice: 'Initializing activation sequence'
        }
      end
      let(:options) { super().merge(flash: flash) }

      it 'should assign the flash', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
        response.call(renderer)

        flash.each do |key, value|
          expect(renderer_flash.now)
            .to have_received(:[]=)
            .with(key, value)
        end
      end

      it 'should render the component' do
        response.call(renderer)

        expect(renderer).to have_received(:render).with(component, **expected)
      end
    end

    context 'when initialized with layout: value' do
      let(:layout)   { 'custom_layout' }
      let(:options)  { super().merge(layout: layout) }
      let(:expected) { super().merge(layout: layout) }

      it 'should render the component' do
        response.call(renderer)

        expect(renderer).to have_received(:render).with(component, **expected)
      end
    end

    context 'when initialized with status: an Integer' do
      let(:status)   { 400 }
      let(:options)  { super().merge(status: status) }
      let(:expected) { super().merge(status: status) }

      it 'should render the component' do
        response.call(renderer)

        expect(renderer).to have_received(:render).with(component, **expected)
      end
    end

    context 'when initialized with status: a Symbol' do
      let(:status)   { :bad_request }
      let(:options)  { super().merge(status: status) }
      let(:expected) { super().merge(status: status) }

      it 'should render the component' do
        response.call(renderer)

        expect(renderer).to have_received(:render).with(component, **expected)
      end
    end
  end

  describe '#component' do
    include_examples 'should define reader', :component, -> { component }
  end

  describe '#flash' do
    include_examples 'should define reader', :flash, {}

    context 'when initialized with flash: a Hash' do
      let(:flash) do
        {
          alert:  'Reactor temperature critical',
          notice: 'Initializing activation sequence'
        }
      end
      let(:options) { super().merge(flash: flash) }

      it { expect(response.flash).to be == flash }
    end
  end

  describe '#layout' do
    include_examples 'should define reader', :layout, nil

    context 'when initialized with layout: value' do
      let(:layout)  { 'custom_layout' }
      let(:options) { super().merge(layout: layout) }

      it { expect(response.layout).to be == layout }
    end
  end

  describe '#status' do
    include_examples 'should define reader', :status, nil

    context 'when initialized with status: an Integer' do
      let(:status)  { 400 }
      let(:options) { super().merge(status: status) }

      it { expect(response.status).to be status }
    end

    context 'when initialized with status: a Symbol' do
      let(:status)  { :bad_request }
      let(:options) { super().merge(status: status) }

      it { expect(response.status).to be status }
    end
  end
end
