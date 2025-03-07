# frozen_string_literal: true

require 'rails_helper'

require 'support/project'
require 'support/user'

RSpec.describe Librum::Core::Actions::Middleware::Associations::Parent do
  subject(:middleware) { described_class.new(**constructor_options) }

  let(:association_params) do
    { entity_class: Spec::Support::User, name: 'user' }
  end
  let(:constructor_options) { association_params }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_any_keywords
    end

    describe 'with invalid association params' do
      let(:association_params) { {} }
      let(:error_message) do
        "name or entity class can't be blank"
      end

      it 'should raise an exception' do
        expect { described_class.new(**constructor_options) }
          .to raise_error ArgumentError, error_message
      end
    end
  end

  describe '#association' do
    let(:association) { middleware.association }
    let(:association_class) do
      Cuprum::Collections::Associations::BelongsTo
    end

    include_examples 'should define reader', :association

    it { expect(association).to be_a association_class }

    it { expect(association.name).to be == 'user' }
  end

  describe '#association_type' do
    include_examples 'should define reader', :association_type, :belongs_to
  end

  describe '#call' do
    shared_context 'with a valid user id' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:user)    { Spec::Support::User.create!(name: 'Alan Bradley') }
      let(:user_id) { user.id }
      let(:params)  { super().merge('user_id' => user_id) }
    end

    shared_context 'with a valid user slug' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:user) do
        Spec::Support::User.create!(name: 'Alan Bradley', slug: 'alan-bradley')
      end
      let(:user_id) { user.slug }
      let(:params)  { super().merge('user_id' => user_id) }
    end

    shared_examples 'should call the next command' do
      it 'should call the next command' do # rubocop:disable RSpec/ExampleLength
        call_command

        expect(next_command).to have_received(:call).with(
          repository: repository,
          request:    request,
          resource:   resource,
          **options
        )
      end

      context 'when called with custom options' do
        let(:options) { super().merge('custom_option' => 'custom value') }

        it 'should call the next command' do # rubocop:disable RSpec/ExampleLength
          call_command

          expect(next_command).to have_received(:call).with(
            repository: repository,
            request:    request,
            resource:   resource,
            **options
          )
        end
      end
    end

    let(:next_result)  { Cuprum::Result.new(value: { 'ok' => true }) }
    let(:next_command) { instance_double(Cuprum::Command, call: next_result) }
    let(:params)       { {} }
    let(:request)      { Cuprum::Rails::Request.new(params: params) }
    let(:repository)   { Cuprum::Rails::Records::Repository.new }
    let(:resource) do
      Cuprum::Rails::Resource.new(
        entity_class: Spec::Support::Project,
        name:         'projects'
      )
    end
    let(:options) { {} }

    def call_command
      middleware.call(
        next_command,
        repository: repository,
        request:    request,
        resource:   resource,
        **options
      )
    end

    it 'should define the method' do
      expect(middleware)
        .to be_callable
        .with(1).argument
        .and_keywords(:repository, :request, :resource)
        .and_any_keywords
    end

    context 'when the parameter is missing' do
      let(:params) { {} }
      let(:expected_error) do
        Cuprum::Rails::Errors::MissingParameter.new(
          parameter_name: 'user_id',
          parameters:     params
        )
      end

      it 'should not call the next command' do
        call_command

        expect(next_command).not_to have_received(:call)
      end

      it 'should return a failing result' do
        expect(call_command)
          .to be_a_failing_result
          .with_error(expected_error)
      end
    end

    context 'when the association is not found by id' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:user_id) { SecureRandom.uuid }
      let(:params)  { super().merge('user_id' => user_id) }
      let(:expected_error) do
        Cuprum::Collections::Errors::NotFound.new(
          attribute_name:  'id',
          attribute_value: user_id,
          collection_name: 'user',
          primary_key:     true
        )
      end

      it 'should not call the next command' do
        call_command

        expect(next_command).not_to have_received(:call)
      end

      it 'should return a failing result' do
        expect(call_command)
          .to be_a_failing_result
          .with_error(expected_error)
      end
    end

    context 'when the association is not found by slug' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:user_id) { 'kevin-flynn' }
      let(:params)  { super().merge('user_id' => user_id) }
      let(:expected_error) do
        Cuprum::Collections::Errors::NotFound.new(
          attribute_name:  'slug',
          attribute_value: user_id,
          collection_name: 'user'
        )
      end

      it 'should not call the next command' do
        call_command

        expect(next_command).not_to have_received(:call)
      end

      it 'should return a failing result' do
        expect(call_command)
          .to be_a_failing_result
          .with_error(expected_error)
      end
    end

    context 'when the association is found by id' do
      include_context 'with a valid user id'

      context 'when the next command does not return a value' do
        let(:next_result) { Cuprum::Result.new }

        include_examples 'should call the next command'

        it 'should return a passing result' do
          expect(call_command)
            .to be_a_passing_result
            .with_value(nil)
        end
      end

      context 'when the next command does not return entities' do
        let(:next_result)    { Cuprum::Result.new(value: { 'ok' => true }) }
        let(:expected_value) { next_result.value.merge('user' => user) }

        include_examples 'should call the next command'

        it 'should return a passing result' do
          expect(call_command)
            .to be_a_passing_result
            .with_value(expected_value)
        end
      end

      context 'when the next command returns entities' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:projects) do
          Array.new(3) do |index|
            Spec::Support::Project.create!(
              'user_id' => user.id,
              'name'    => "Project #{index}"
            )
          end
        end
        let(:next_result) do
          Cuprum::Result.new(value: { 'ok' => true, 'projects' => projects })
        end
        let(:expected_value) { next_result.value.merge('user' => user) }

        def cached_values(entities)
          entities
            .map { |entity| entity.send(:association_instance_get, 'user') }
        end

        include_examples 'should call the next command'

        it 'should return a passing result' do
          expect(call_command)
            .to be_a_passing_result
            .with_value(expected_value)
        end

        it 'should cache the association' do
          value = call_command.value

          expect(cached_values(value['projects'])).to be == [user, user, user]
        end
      end

      context 'when the next command returns a failing result' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        include_context 'with a valid user id'

        let(:next_error) { Cuprum::Error.new(message: 'Something went wrong.') }
        let(:next_value) { { 'ok' => false } }
        let(:next_result) do
          Cuprum::Result.new(error: next_error, value: next_value)
        end
        let(:expected_value) { next_result.value.merge('user' => user) }

        include_examples 'should call the next command'

        it 'should return a passing result' do
          expect(call_command)
            .to be_a_failing_result
            .with_error(next_error)
            .and_value(expected_value)
        end
      end

      context 'when initialized with a singular resource' do
        let(:resource) do
          Cuprum::Rails::Resource.new(name: 'project', singular: true)
        end

        context 'when the next command returns an entity' do # rubocop:disable RSpec/MultipleMemoizedHelpers
          let(:project) do
            Spec::Support::Project.create!(
              'user_id' => user.id,
              'name'    => 'Secret Project'
            )
          end
          let(:next_result) do
            Cuprum::Result.new(value: { 'ok' => true, 'project' => project })
          end
          let(:expected_value) { next_result.value.merge('user' => user) }

          def cached_value(entity)
            entity.send(:association_instance_get, 'user')
          end

          include_examples 'should call the next command'

          it 'should return a passing result' do
            expect(call_command)
              .to be_a_passing_result
              .with_value(expected_value)
          end

          it 'should cache the association' do
            value = call_command.value

            expect(cached_value(value['project'])).to be == user
          end
        end
      end
    end

    context 'when the association is found by slug' do
      include_context 'with a valid user slug'

      context 'when the next command does not return a value' do
        let(:next_result) { Cuprum::Result.new }

        include_examples 'should call the next command'

        it 'should return a passing result' do
          expect(call_command)
            .to be_a_passing_result
            .with_value(nil)
        end
      end

      context 'when the next command does not return entities' do
        let(:next_result)    { Cuprum::Result.new(value: { 'ok' => true }) }
        let(:expected_value) { next_result.value.merge('user' => user) }

        include_examples 'should call the next command'

        it 'should return a passing result' do
          expect(call_command)
            .to be_a_passing_result
            .with_value(expected_value)
        end
      end

      context 'when the next command returns entities' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:projects) do
          Array.new(3) do |index|
            Spec::Support::Project.create!(
              'user_id' => user.id,
              'name'    => "Project #{index}"
            )
          end
        end
        let(:next_result) do
          Cuprum::Result.new(value: { 'ok' => true, 'projects' => projects })
        end
        let(:expected_value) { next_result.value.merge('user' => user) }

        def cached_values(entities)
          entities
            .map { |entity| entity.send(:association_instance_get, 'user') }
        end

        include_examples 'should call the next command'

        it 'should return a passing result' do
          expect(call_command)
            .to be_a_passing_result
            .with_value(expected_value)
        end

        it 'should cache the association' do
          value = call_command.value

          expect(cached_values(value['projects'])).to be == [user, user, user]
        end
      end

      context 'when the next command returns a failing result' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        include_context 'with a valid user id'

        let(:next_error) { Cuprum::Error.new(message: 'Something went wrong.') }
        let(:next_value) { { 'ok' => false } }
        let(:next_result) do
          Cuprum::Result.new(error: next_error, value: next_value)
        end
        let(:expected_value) { next_result.value.merge('user' => user) }

        include_examples 'should call the next command'

        it 'should return a passing result' do
          expect(call_command)
            .to be_a_failing_result
            .with_error(next_error)
            .and_value(expected_value)
        end
      end

      context 'when initialized with a singular resource' do
        let(:resource) do
          Cuprum::Rails::Resource.new(name: 'project', singular: true)
        end

        context 'when the next command returns an entity' do # rubocop:disable RSpec/MultipleMemoizedHelpers
          let(:project) do
            Spec::Support::Project.create!(
              'user_id' => user.id,
              'name'    => 'Secret Project'
            )
          end
          let(:next_result) do
            Cuprum::Result.new(value: { 'ok' => true, 'project' => project })
          end
          let(:expected_value) { next_result.value.merge('user' => user) }

          def cached_value(entity)
            entity.send(:association_instance_get, 'user')
          end

          include_examples 'should call the next command'

          it 'should return a passing result' do
            expect(call_command)
              .to be_a_passing_result
              .with_value(expected_value)
          end

          it 'should cache the association' do
            value = call_command.value

            expect(cached_value(value['project'])).to be == user
          end
        end
      end
    end
  end
end
