# frozen_string_literal: true

require 'rails_helper'

require 'stannum/errors'

require 'support/models/rocket'

RSpec.describe Librum::Core::View::Components::Resources::Form,
  type: :component \
do
  subject(:form) { described_class.new(**constructor_options) }

  shared_context 'with errors' do
    let(:errors) do
      Stannum::Errors.new.add('spec.error', message: 'Something went wrong')
    end
    let(:constructor_options) { super().merge(errors: errors) }
  end

  let(:data) do
    { 'rocket' => Rocket.new(name: 'Imp IV', slug: 'imp-iv') }
  end
  let(:action)   { 'new' }
  let(:resource) { Cuprum::Rails::Resource.new(name: 'rockets') }
  let(:constructor_options) do
    {
      action:   action,
      data:     data,
      resource: resource
    }
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:action, :data, :errors, :resource)
        .and_any_keywords
    end
  end

  describe '#action' do
    include_examples 'should define reader', :action, -> { action }
  end

  describe '#data' do
    include_examples 'should define reader', :data, -> { data }
  end

  describe '#errors' do
    include_examples 'should define reader', :errors, nil

    wrap_context 'with errors' do
      it { expect(form.errors).to be == errors }
    end
  end

  describe '#render_form' do
    let(:described_class) { Spec::CustomForm }
    let(:rendered)        { render_inline(form) }
    let(:block)           { nil }

    # rubocop:disable RSpec/DescribedClass
    example_class 'Spec::CustomForm',
      Librum::Core::View::Components::Resources::Form \
    do |klass|
      form_block = block

      klass.define_method(:call) { render_form(&form_block) }
    end
    # rubocop:enable RSpec/DescribedClass

    it 'should define the method' do
      expect(form).to respond_to(:render_form).with(0).arguments.and_a_block
    end

    context 'when initialized with action: "edit"' do
      let(:action) { 'edit' }
      let(:snapshot) do
        <<~HTML
          <form action="/rockets/imp-iv" accept-charset="UTF-8" method="post">
            <input type="hidden" name="_method" value="patch" autocomplete="off">

            <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">
          </form>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with a block' do
        let(:block) { ->(*) { form.render_form_field 'name' } }
        let(:snapshot) do
          <<~HTML
            <form action="/rockets/imp-iv" accept-charset="UTF-8" method="post">
              <input type="hidden" name="_method" value="patch" autocomplete="off">

              <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

              <div class="field">
                <label for="name" class="label">Name</label>

                <div class="control">
                  <input id="name" name="name" class="input" type="text">
                </div>
              </div>
            </form>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      context 'when initialized with a resource with base_url: value' do
        let(:resource) do
          Cuprum::Rails::Resource.new(
            base_path: '/path/to/rockets',
            name:      'rockets'
          )
        end
        let(:snapshot) do
          <<~HTML
            <form action="/path/to/rockets/imp-iv" accept-charset="UTF-8" method="post">
              <input type="hidden" name="_method" value="patch" autocomplete="off">

              <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">
            </form>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      context 'when initialized with routes: value' do
        let(:routes) do
          Cuprum::Rails::Routing::PluralRoutes
            .new(base_path: '/path/to/rockets')
        end
        let(:constructor_options) { super().merge(routes: routes) }
        let(:snapshot) do
          <<~HTML
            <form action="/path/to/rockets/imp-iv" accept-charset="UTF-8" method="post">
              <input type="hidden" name="_method" value="patch" autocomplete="off">

              <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">
            </form>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    context 'when initialized with action: "new"' do
      let(:action) { 'new' }
      let(:snapshot) do
        <<~HTML
          <form action="/rockets" accept-charset="UTF-8" method="post">
            <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">
          </form>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with a block' do
        let(:block) { ->(*) { form.render_form_field 'name' } }
        let(:snapshot) do
          <<~HTML
            <form action="/rockets" accept-charset="UTF-8" method="post">
              <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

              <div class="field">
                <label for="name" class="label">Name</label>

                <div class="control">
                  <input id="name" name="name" class="input" type="text">
                </div>
              </div>
            </form>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      context 'when initialized with a resource with base_url: value' do
        let(:resource) do
          Cuprum::Rails::Resource.new(
            base_path: '/path/to/rockets',
            name:      'rockets'
          )
        end
        let(:snapshot) do
          <<~HTML
            <form action="/path/to/rockets" accept-charset="UTF-8" method="post">
              <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">
            </form>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      context 'when initialized with routes: value' do
        let(:routes) do
          Cuprum::Rails::Routing::PluralRoutes
            .new(base_path: '/path/to/rockets')
        end
        let(:constructor_options) { super().merge(routes: routes) }
        let(:snapshot) do
          <<~HTML
            <form action="/path/to/rockets" accept-charset="UTF-8" method="post">
              <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">
            </form>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end
  end

  describe '#render_form_actions' do
    let(:described_class) { Spec::CustomForm }
    let(:rendered)        { render_inline(form) }

    # rubocop:disable RSpec/DescribedClass
    example_class 'Spec::CustomForm',
      Librum::Core::View::Components::Resources::Form \
    do |klass|
      klass.define_method(:call) { render_form_actions }
    end
    # rubocop:enable RSpec/DescribedClass

    it { expect(form).to respond_to(:render_form_actions).with(0).arguments }

    context 'when initialized with action: "edit"' do
      let(:action) { 'edit' }
      let(:snapshot) do
        <<~HTML
          <div class="field mt-5">
            <div class="control">
              <div class="columns">
                <div class="column is-half-tablet is-one-quarter-desktop">
                  <button type="submit" class="button is-primary is-fullwidth">Update Rocket</button>
                </div>

                <div class="column is-half-tablet is-one-quarter-desktop">
                  <a class="button is-fullwidth has-text-black" href="/rockets/imp-iv" target="_self">
                    Cancel
                  </a>
                </div>
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      context 'when initialized with a resource with base_url: value' do
        let(:resource) do
          Cuprum::Rails::Resource.new(
            base_path: '/path/to/rockets',
            name:      'rockets'
          )
        end
        let(:snapshot) do
          <<~HTML
            <div class="field mt-5">
              <div class="control">
                <div class="columns">
                  <div class="column is-half-tablet is-one-quarter-desktop">
                    <button type="submit" class="button is-primary is-fullwidth">Update Rocket</button>
                  </div>

                  <div class="column is-half-tablet is-one-quarter-desktop">
                    <a class="button is-fullwidth has-text-black" href="/path/to/rockets/imp-iv" target="_self">
                      Cancel
                    </a>
                  </div>
                </div>
              </div>
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      context 'when initialized with routes: value' do
        let(:routes) do
          Cuprum::Rails::Routing::PluralRoutes
            .new(base_path: '/path/to/rockets')
        end
        let(:constructor_options) { super().merge(routes: routes) }
        let(:snapshot) do
          <<~HTML
            <div class="field mt-5">
              <div class="control">
                <div class="columns">
                  <div class="column is-half-tablet is-one-quarter-desktop">
                    <button type="submit" class="button is-primary is-fullwidth">Update Rocket</button>
                  </div>

                  <div class="column is-half-tablet is-one-quarter-desktop">
                    <a class="button is-fullwidth has-text-black" href="/path/to/rockets/imp-iv" target="_self">
                      Cancel
                    </a>
                  </div>
                </div>
              </div>
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    context 'when initialized with action: "new"' do
      let(:action) { 'new' }
      let(:snapshot) do
        <<~HTML
          <div class="field mt-5">
            <div class="control">
              <div class="columns">
                <div class="column is-half-tablet is-one-quarter-desktop">
                  <button type="submit" class="button is-primary is-fullwidth">Create Rocket</button>
                </div>

                <div class="column is-half-tablet is-one-quarter-desktop">
                  <a class="button is-fullwidth has-text-black" href="/rockets" target="_self">
                    Cancel
                  </a>
                </div>
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      context 'when initialized with a resource with base_url: value' do
        let(:resource) do
          Cuprum::Rails::Resource.new(
            base_path: '/path/to/rockets',
            name:      'rockets'
          )
        end
        let(:snapshot) do
          <<~HTML
            <div class="field mt-5">
              <div class="control">
                <div class="columns">
                  <div class="column is-half-tablet is-one-quarter-desktop">
                    <button type="submit" class="button is-primary is-fullwidth">Create Rocket</button>
                  </div>

                  <div class="column is-half-tablet is-one-quarter-desktop">
                    <a class="button is-fullwidth has-text-black" href="/path/to/rockets" target="_self">
                      Cancel
                    </a>
                  </div>
                </div>
              </div>
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      context 'when initialized with routes: value' do
        let(:routes) do
          Cuprum::Rails::Routing::PluralRoutes
            .new(base_path: '/path/to/rockets')
        end
        let(:constructor_options) { super().merge(routes: routes) }
        let(:snapshot) do
          <<~HTML
            <div class="field mt-5">
              <div class="control">
                <div class="columns">
                  <div class="column is-half-tablet is-one-quarter-desktop">
                    <button type="submit" class="button is-primary is-fullwidth">Create Rocket</button>
                  </div>

                  <div class="column is-half-tablet is-one-quarter-desktop">
                    <a class="button is-fullwidth has-text-black" href="/path/to/rockets" target="_self">
                      Cancel
                    </a>
                  </div>
                </div>
              </div>
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end
  end

  describe '#render_form_field' do
    let(:described_class) { Spec::CustomForm }
    let(:rendered)        { render_inline(form) }
    let(:name)            { 'color' }
    let(:options)         { {} }
    let(:snapshot) do
      <<~HTML
        <div class="field">
          <label for="color" class="label">Color</label>

          <div class="control">
            <input id="color" name="color" class="input" type="text">
          </div>
        </div>
      HTML
    end

    # rubocop:disable RSpec/DescribedClass
    example_class 'Spec::CustomForm',
      Librum::Core::View::Components::Resources::Form \
    do |klass|
      field_name    = name
      field_options = options

      klass.define_method(:call) do
        render_form_field(field_name, **field_options)
      end
    end
    # rubocop:enable RSpec/DescribedClass

    it 'should define the method' do
      expect(form)
        .to respond_to(:render_form_field)
        .with(1).argument
        .and_any_keywords
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with name: compound value' do
      let(:name) { 'rocket[color]' }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label for="rocket_color" class="label">Color</label>

            <div class="control">
              <input id="rocket_color" name="rocket[color]" class="input" type="text">
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with options: value' do
      let(:options) { super().merge(placeholder: 'Placeholder Value') }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label for="color" class="label">Color</label>

            <div class="control">
              <input id="color" name="color" class="input" placeholder="Placeholder Value" type="text">
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    context 'when initialized with data: an object with matching key' do
      let(:data) do
        Rocket.new(
          name:  'Imp IV',
          slug:  'imp-iv',
          color: 'red'
        )
      end
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label for="color" class="label">Color</label>

            <div class="control">
              <input id="color" name="color" class="input" type="text" value="red">
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with name: compound value' do
        let(:name) { 'rocket[color]' }
        let(:data) { { 'rocket' => super() } }
        let(:snapshot) do
          <<~HTML
            <div class="field">
              <label for="rocket_color" class="label">Color</label>

              <div class="control">
                <input id="rocket_color" name="rocket[color]" class="input" type="text" value="red">
              </div>
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    context 'when initialized with errors: matching errors' do
      let(:errors) do
        errors = Stannum::Errors.new
        errors['color'].add('spec.error', message: 'Something went wrong')
        errors
      end
      let(:constructor_options) { super().merge(errors: errors) }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label for="color" class="label">Color</label>

            <div class="control has-icons-right">
              <input id="color" name="color" class="input is-danger" type="text">

              <span class="icon is-right is-small">
                <i class="fas fa-triangle-exclamation"></i>
              </span>
            </div>

            <p class="help is-danger">Something went wrong</p>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with name: compound value' do
        let(:name) { 'rocket[color]' }
        let(:errors) do
          errors = Stannum::Errors.new
          errors['rocket']['color']
            .add('spec.error', message: 'Something went wrong')
          errors
        end
        let(:snapshot) do
          <<~HTML
            <div class="field">
              <label for="rocket_color" class="label">Color</label>

              <div class="control has-icons-right">
                <input id="rocket_color" name="rocket[color]" class="input is-danger" type="text">

                <span class="icon is-right is-small">
                  <i class="fas fa-triangle-exclamation"></i>
                </span>
              </div>

              <p class="help is-danger">Something went wrong</p>
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end
  end

  describe '#render_form_radio_button_group' do
    let(:described_class) { Spec::CustomForm }
    let(:rendered)        { render_inline(form) }
    let(:name)            { 'color' }
    let(:options)         { {} }
    let(:items) do
      [
        { value: 'red' },
        { value: 'green' },
        { value: 'blue' }
      ]
    end
    let(:snapshot) do
      <<~HTML
        <div class="field">
          <label class="label">Color</label>

          <div class="control">
            <div class="columns">
              <div class="column">
                <label class="radio" name="color">
                  <input name="color" type="radio" value="red">

                  Red
                </label>
              </div>

              <div class="column">
                <label class="radio" name="color">
                  <input name="color" type="radio" value="green">

                  Green
                </label>
              </div>

              <div class="column">
                <label class="radio" name="color">
                  <input name="color" type="radio" value="blue">

                  Blue
                </label>
              </div>
            </div>
          </div>
        </div>
      HTML
    end

    # rubocop:disable RSpec/DescribedClass
    example_class 'Spec::CustomForm',
      Librum::Core::View::Components::Resources::Form \
    do |klass|
      field_name    = name
      field_items   = items
      field_options = options

      klass.define_method(:call) do
        render_form_radio_button_group(
          field_name,
          items: field_items,
          **field_options
        )
      end
    end
    # rubocop:enable RSpec/DescribedClass

    it 'should define the method' do
      expect(form)
        .to respond_to(:render_form_radio_button_group)
        .with(1).argument
        .and_keywords(:items)
        .and_any_keywords
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with name: compound value' do
      let(:name) { 'rocket[color]' }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label class="label">Color</label>

            <div class="control">
              <div class="columns">
                <div class="column">
                  <label class="radio" name="rocket[color]">
                    <input name="rocket[color]" type="radio" value="red">

                    Red
                  </label>
                </div>

                <div class="column">
                  <label class="radio" name="rocket[color]">
                    <input name="rocket[color]" type="radio" value="green">

                    Green
                  </label>
                </div>

                <div class="column">
                  <label class="radio" name="rocket[color]">
                    <input name="rocket[color]" type="radio" value="blue">

                    Blue
                  </label>
                </div>
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with options: value' do
      let(:options) { super().merge(label: 'Chroma') }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label class="label">Chroma</label>

            <div class="control">
              <div class="columns">
                <div class="column">
                  <label class="radio" name="color">
                    <input name="color" type="radio" value="red">

                    Red
                  </label>
                </div>

                <div class="column">
                  <label class="radio" name="color">
                    <input name="color" type="radio" value="green">

                    Green
                  </label>
                </div>

                <div class="column">
                  <label class="radio" name="color">
                    <input name="color" type="radio" value="blue">

                    Blue
                  </label>
                </div>
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    context 'when initialized with data: an object with matching key' do
      let(:data) do
        Rocket.new(
          name:  'Imp IV',
          slug:  'imp-iv',
          color: 'red'
        )
      end
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label class="label">Color</label>

            <div class="control">
              <div class="columns">
                <div class="column">
                  <label class="radio" name="color">
                    <input name="color" type="radio" value="red" checked>

                    Red
                  </label>
                </div>

                <div class="column">
                  <label class="radio" name="color">
                    <input name="color" type="radio" value="green">

                    Green
                  </label>
                </div>

                <div class="column">
                  <label class="radio" name="color">
                    <input name="color" type="radio" value="blue">

                    Blue
                  </label>
                </div>
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    context 'when initialized with errors: matching errors' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:errors) do
        errors = Stannum::Errors.new
        errors['color'].add('spec.error', message: 'Something went wrong')
        errors
      end
      let(:constructor_options) { super().merge(errors: errors) }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label class="label">Color</label>

            <div class="control has-icons-right">
              <div class="columns">
                <div class="column">
                  <label class="radio has-text-danger" name="color">
                    <input name="color" type="radio" value="red">

                    Red
                  </label>
                </div>

                <div class="column">
                  <label class="radio has-text-danger" name="color">
                    <input name="color" type="radio" value="green">

                    Green
                  </label>
                </div>

                <div class="column">
                  <label class="radio has-text-danger" name="color">
                    <input name="color" type="radio" value="blue">

                    Blue
                  </label>
                </div>
              </div>

              <span class="icon is-right is-small">
                <i class="fas fa-triangle-exclamation"></i>
              </span>
            </div>

            <p class="help is-danger">Something went wrong</p>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#resource' do
    include_examples 'should define reader', :resource, -> { resource }
  end

  describe '#routes' do
    include_examples 'should define reader', :routes

    it 'should return the resource routes', :aggregate_failures do
      expect(form.routes).to be_a(resource.routes.class)

      expect(form.routes.base_path).to be == resource.routes.base_path
    end

    context 'when initialized with routes: value' do
      let(:routes) do
        Cuprum::Rails::Routing::PluralRoutes.new(base_path: '/path/to/rockets')
      end
      let(:constructor_options) { super().merge(routes: routes) }

      it { expect(form.routes).to be == routes }
    end
  end
end
