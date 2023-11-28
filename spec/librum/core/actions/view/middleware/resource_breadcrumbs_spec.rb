# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::Actions::View::Middleware::ResourceBreadcrumbs do
  subject(:middleware) do
    described_class.new(breadcrumbs: breadcrumbs, resource: resource, **options)
  end

  let(:breadcrumbs) do
    [
      {
        label: 'Home',
        url:   '/'
      },
      {
        label: 'Rockets',
        url:   '/rockets'
      }
    ]
  end
  let(:resource) { Cuprum::Rails::Resource.new(name: 'rockets') }
  let(:options)  { {} }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:actions, :breadcrumbs, :resource)
        .and_any_keywords
    end
  end

  describe '#actions' do
    include_examples 'should define reader', :actions

    context 'when initialized with resource: a plural resource' do
      let(:expected) do
        {
          create: [{ label: 'Create', url: '/rockets/new' }],
          edit:   [
            { label: ':name', url: '/rockets/:slug' },
            { label: 'Update', url: '/rockets/:slug/edit' }
          ],
          index:  [],
          new:    [{ label: 'Create', url: '/rockets/new' }],
          show:   [{ label: ':name', url: '/rockets/:slug' }],
          update: [
            { label: ':name', url: '/rockets/:slug' },
            { label: 'Update', url: '/rockets/:slug/edit' }
          ]
        }
      end

      it { expect(middleware.actions).to be == expected }

      context 'when initialized with actions: value' do
        let(:actions) do
          {
            index:  [
              {
                label: 'Index',
                url:   ':base_url'
              }
            ],
            search: [
              {
                label: 'Advanced Actions',
                url:   ':base_url/advanced_actions'
              },
              {
                label: 'Search',
                url:   ':base_url/advanced_actions/search'
              }
            ],
            launch: [
              {
                label: 'Advanced Actions',
                url:   ':base_url/advanced_actions'
              },
              {
                label: ':name',
                url:   ':base_url/advanced_actions/:slug'
              },
              {
                label: 'Launch',
                url:   ':base_url/advanced_actions/:slug/launch'
              }
            ]
          }
        end
        let(:options)  { super().merge(actions: actions) }
        let(:expected) { super().merge(actions) }

        it { expect(middleware.actions).to be == expected }
      end
    end

    context 'when initialized with resource: a singular resource' do
      let(:breadcrumbs) do
        [
          {
            label: 'Home',
            url:   '/'
          },
          {
            label: 'Rocket',
            url:   '/rocket'
          }
        ]
      end
      let(:resource) do
        Cuprum::Rails::Resource.new(
          name:     'rocket',
          singular: true
        )
      end
      let(:expected) do
        {
          create: [{ label: 'Create', url: '/rocket/new' }],
          edit:   [{ label: 'Update', url: '/rocket/edit' }],
          new:    [{ label: 'Create', url: '/rocket/new' }],
          show:   [],
          update: [{ label: 'Update', url: '/rocket/edit' }]
        }
      end

      it { expect(middleware.actions).to be == expected }

      context 'when initialized with actions: value' do
        let(:actions) do
          {
            show:   [
              {
                label: 'Show',
                url:   ':base_url'
              }
            ],
            launch: [
              {
                label: 'Advanced Actions',
                url:   ':base_url/advanced_actions'
              },
              {
                label: 'Launch',
                url:   ':base_url/advanced_actions/launch'
              }
            ]
          }
        end
        let(:options)  { super().merge(actions: actions) }
        let(:expected) { super().merge(actions) }

        it { expect(middleware.actions).to be == expected }
      end
    end
  end

  describe '#action_name' do
    include_examples 'should define reader', :action_name

    context 'when the middleware has been called' do
      let(:next_result)  { Cuprum::Rails::Result.new(value: { 'ok' => true }) }
      let(:next_command) { instance_double(Cuprum::Command, call: next_result) }
      let(:action_name)  { :index }
      let(:request) do
        Cuprum::Rails::Request.new(action_name: action_name)
      end

      before(:example) { middleware.call(next_command, request: request) }

      it { expect(middleware.action_name).to be action_name }
    end
  end

  describe '#breadcrumbs' do
    include_examples 'should define reader', :breadcrumbs, -> { breadcrumbs }
  end

  # rubocop:disable RSpec/MultipleMemoizedHelpers, RSpec/NestedGroups
  describe '#call' do
    shared_examples 'should merge the metadata' do
      it 'should return the result with merged metadata' do
        expect(middleware.call(next_command, request: request))
          .to be_a_passing_result(Cuprum::Rails::Result)
          .with_value(next_result.value)
          .and_error(next_result.error)
          .and_metadata(expected_metadata)
      end
    end

    let(:next_result)   { Cuprum::Rails::Result.new(value: { 'ok' => true }) }
    let(:next_command)  { instance_double(Cuprum::Command, call: next_result) }
    let(:action_name)   { :index }
    let(:member_action) { false }
    let(:path_params)   { {} }
    let(:request) do
      Cuprum::Rails::Request.new(
        action_name:   action_name,
        member_action: member_action,
        path_params:   path_params
      )
    end
    let(:expected_breadcrumbs) { [] }
    let(:page_metadata) do
      { breadcrumbs: expected_breadcrumbs }
    end
    let(:expected_metadata) do
      { page: page_metadata }
    end

    it 'should call the next command' do
      middleware.call(next_command, request: request)

      expect(next_command).to have_received(:call).with(request: request)
    end

    context 'when initialized with resource: a plural resource' do
      describe 'with action_name: :create' do
        let(:action_name)   { :create }
        let(:member_action) { false }
        let(:expected_breadcrumbs) do
          [
            *breadcrumbs,
            {
              active: true,
              label:  'Create',
              url:    '/rockets/new'
            }
          ]
        end

        include_examples 'should merge the metadata'
      end

      describe 'with action_name: :edit' do
        let(:action_name)   { :edit }
        let(:member_action) { true }
        let(:expected_breadcrumbs) do
          [
            *breadcrumbs,
            {
              label: 'Rocket',
              url:   '/rockets'
            },
            {
              active: true,
              label:  'Update',
              url:    '/rockets'
            }
          ]
        end

        include_examples 'should merge the metadata'

        context 'when the result value is not a Hash' do
          let(:next_result) { Cuprum::Rails::Result.new }

          include_examples 'should merge the metadata'
        end

        context 'when the result has resource data' do
          let(:value) do
            {
              'rocket' => {
                'name' => 'Imp IV',
                'slug' => 'imp-iv'
              }
            }
          end
          let(:next_result) { Cuprum::Rails::Result.new(value: value) }
          let(:expected_breadcrumbs) do
            [
              *breadcrumbs,
              {
                label: 'Imp IV',
                url:   '/rockets/imp-iv'
              },
              {
                active: true,
                label:  'Update',
                url:    '/rockets/imp-iv/edit'
              }
            ]
          end

          include_examples 'should merge the metadata'
        end
      end

      describe 'with action_name: :index' do
        let(:action_name)   { :index }
        let(:member_action) { false }
        let(:expected_breadcrumbs) do
          *rest, last = breadcrumbs

          [*rest, last.merge(active: true)]
        end

        include_examples 'should merge the metadata'
      end

      describe 'with action_name: :new' do
        let(:action_name)   { :new }
        let(:member_action) { false }
        let(:expected_breadcrumbs) do
          [
            *breadcrumbs,
            {
              active: true,
              label:  'Create',
              url:    '/rockets/new'
            }
          ]
        end

        include_examples 'should merge the metadata'
      end

      describe 'with action_name: :show' do
        let(:action_name)   { :show }
        let(:member_action) { true }
        let(:expected_breadcrumbs) do
          [
            *breadcrumbs,
            {
              active: true,
              label:  'Rocket',
              url:    '/rockets'
            }
          ]
        end

        include_examples 'should merge the metadata'

        context 'when the result value is not a Hash' do
          let(:next_result) { Cuprum::Rails::Result.new }

          include_examples 'should merge the metadata'
        end

        context 'when the result has resource data' do
          let(:value) do
            {
              'rocket' => {
                'name' => 'Imp IV',
                'slug' => 'imp-iv'
              }
            }
          end
          let(:next_result) { Cuprum::Rails::Result.new(value: value) }
          let(:expected_breadcrumbs) do
            [
              *breadcrumbs,
              {
                active: true,
                label:  'Imp IV',
                url:    '/rockets/imp-iv'
              }
            ]
          end

          include_examples 'should merge the metadata'
        end
      end

      describe 'with action_name: :update' do
        let(:action_name)   { :update }
        let(:member_action) { true }
        let(:expected_breadcrumbs) do
          [
            *breadcrumbs,
            {
              label: 'Rocket',
              url:   '/rockets'
            },
            {
              active: true,
              label:  'Update',
              url:    '/rockets'
            }
          ]
        end

        include_examples 'should merge the metadata'

        context 'when the result value is not a Hash' do
          let(:next_result) { Cuprum::Rails::Result.new }

          include_examples 'should merge the metadata'
        end

        context 'when the result has resource data' do
          let(:value) do
            {
              'rocket' => {
                'name' => 'Imp IV',
                'slug' => 'imp-iv'
              }
            }
          end
          let(:next_result) { Cuprum::Rails::Result.new(value: value) }
          let(:expected_breadcrumbs) do
            [
              *breadcrumbs,
              {
                label: 'Imp IV',
                url:   '/rockets/imp-iv'
              },
              {
                active: true,
                label:  'Update',
                url:    '/rockets/imp-iv/edit'
              }
            ]
          end

          include_examples 'should merge the metadata'
        end
      end

      describe 'with a custom collection action' do
        let(:action_name)   { :search }
        let(:member_action) { false }
        let(:expected_breadcrumbs) do
          [
            *breadcrumbs,
            {
              active: true,
              label:  'Search',
              url:    '/rockets/search'
            }
          ]
        end

        include_examples 'should merge the metadata'
      end

      describe 'with a custom member action' do
        let(:action_name)   { :launch }
        let(:member_action) { true }
        let(:expected_breadcrumbs) do
          [
            *breadcrumbs,
            {
              label: 'Rocket',
              url:   '/rockets'
            },
            {
              active: true,
              label:  'Launch',
              url:    '/rockets'
            }
          ]
        end

        include_examples 'should merge the metadata'

        context 'when the result value is not a Hash' do
          let(:next_result) { Cuprum::Rails::Result.new }

          include_examples 'should merge the metadata'
        end

        context 'when the result has resource data' do
          let(:value) do
            {
              'rocket' => {
                'name' => 'Imp IV',
                'slug' => 'imp-iv'
              }
            }
          end
          let(:next_result) { Cuprum::Rails::Result.new(value: value) }
          let(:expected_breadcrumbs) do
            [
              *breadcrumbs,
              {
                label: 'Imp IV',
                url:   '/rockets/imp-iv'
              },
              {
                active: true,
                label:  'Launch',
                url:    '/rockets/imp-iv/launch'
              }
            ]
          end

          include_examples 'should merge the metadata'
        end
      end

      context 'when initialized with actions: value' do
        let(:actions) do
          {
            index:  [
              {
                label: 'Index',
                url:   ':base_url'
              }
            ],
            search: [
              {
                label: 'Advanced Actions',
                url:   ':base_url/advanced_actions'
              },
              {
                label: 'Search',
                url:   ':base_url/advanced_actions/search'
              }
            ],
            launch: [
              {
                label: 'Advanced Actions',
                url:   ':base_url/advanced_actions'
              },
              {
                label: ':name',
                url:   ':base_url/advanced_actions/:slug'
              },
              {
                label: 'Launch',
                url:   ':base_url/advanced_actions/:slug/launch'
              }
            ]
          }
        end
        let(:options) { super().merge(actions: actions) }

        describe 'with action_name: :index' do
          let(:action_name)   { :index }
          let(:member_action) { false }
          let(:expected_breadcrumbs) do
            [
              *breadcrumbs,
              {
                active: true,
                label:  'Index',
                url:    '/rockets'
              }
            ]
          end

          include_examples 'should merge the metadata'
        end

        describe 'with a custom collection action' do
          let(:action_name)   { :search }
          let(:member_action) { false }
          let(:expected_breadcrumbs) do
            [
              *breadcrumbs,
              {
                label: 'Advanced Actions',
                url:   '/rockets/advanced_actions'
              },
              {
                active: true,
                label:  'Search',
                url:    '/rockets/advanced_actions/search'
              }
            ]
          end

          include_examples 'should merge the metadata'
        end

        describe 'with a custom member action' do
          let(:action_name)   { :launch }
          let(:member_action) { true }
          let(:expected_breadcrumbs) do
            [
              *breadcrumbs,
              {
                label: 'Advanced Actions',
                url:   '/rockets/advanced_actions'
              },
              {
                label: 'Rocket',
                url:   '/rockets'
              },
              {
                active: true,
                label:  'Launch',
                url:    '/rockets'
              }
            ]
          end

          include_examples 'should merge the metadata'

          context 'when the result value is not a Hash' do
            let(:next_result) { Cuprum::Rails::Result.new }

            include_examples 'should merge the metadata'
          end

          context 'when the result has resource data' do
            let(:value) do
              {
                'rocket' => {
                  'name' => 'Imp IV',
                  'slug' => 'imp-iv'
                }
              }
            end
            let(:next_result) { Cuprum::Rails::Result.new(value: value) }
            let(:expected_breadcrumbs) do
              [
                *breadcrumbs,
                {
                  label: 'Advanced Actions',
                  url:   '/rockets/advanced_actions'
                },
                {
                  label: 'Imp IV',
                  url:   '/rockets/advanced_actions/imp-iv'
                },
                {
                  active: true,
                  label:  'Launch',
                  url:    '/rockets/advanced_actions/imp-iv/launch'
                }
              ]
            end

            include_examples 'should merge the metadata'
          end
        end
      end

      context 'when initialized with a base_url with path wildcards' do
        let(:action_name)   { :index }
        let(:member_action) { false }
        let(:path_params)   { { 'rocket_id' => 'imp-iv' } }
        let(:breadcrumbs) do
          [
            {
              label: 'Home',
              url:   '/'
            },
            {
              label: 'Rockets',
              url:   '/rockets'
            },
            {
              label: 'Rocket',
              url:   '/rockets/:rocket_id'
            },
            {
              label: 'Launches',
              url:   '/rockets/:rocket_id/launches'
            }
          ]
        end
        let(:expected_breadcrumbs) do
          *rest, last = breadcrumbs.map do |hsh|
            {
              label: hsh[:label],
              url:   hsh[:url].gsub(':rocket_id', 'imp-iv')
            }
          end

          [*rest, last.merge(active: true)]
        end

        include_examples 'should merge the metadata'
      end
    end

    context 'when initialized with resource: a singular resource' do
      let(:breadcrumbs) do
        [
          {
            label: 'Home',
            url:   '/'
          },
          {
            label: 'Rocket',
            url:   '/rocket'
          }
        ]
      end
      let(:resource) do
        Cuprum::Rails::Resource.new(
          name:     'rocket',
          singular: true
        )
      end

      describe 'with action_name: :create' do
        let(:action_name)   { :create }
        let(:member_action) { false }
        let(:expected_breadcrumbs) do
          [
            *breadcrumbs,
            {
              active: true,
              label:  'Create',
              url:    '/rocket/new'
            }
          ]
        end

        include_examples 'should merge the metadata'
      end

      describe 'with action_name: :edit' do
        let(:action_name)   { :edit }
        let(:member_action) { false }
        let(:expected_breadcrumbs) do
          [
            *breadcrumbs,
            {
              active: true,
              label:  'Update',
              url:    '/rocket/edit'
            }
          ]
        end

        include_examples 'should merge the metadata'
      end

      describe 'with action_name: :show' do
        let(:action_name)   { :show }
        let(:member_action) { false }
        let(:expected_breadcrumbs) do
          *rest, last = breadcrumbs

          [*rest, last.merge(active: true)]
        end

        include_examples 'should merge the metadata'
      end

      describe 'with action_name: :new' do
        let(:action_name)   { :new }
        let(:member_action) { false }
        let(:expected_breadcrumbs) do
          [
            *breadcrumbs,
            {
              active: true,
              label:  'Create',
              url:    '/rocket/new'
            }
          ]
        end

        include_examples 'should merge the metadata'
      end

      describe 'with action_name: :update' do
        let(:action_name)   { :update }
        let(:member_action) { false }
        let(:expected_breadcrumbs) do
          [
            *breadcrumbs,
            {
              active: true,
              label:  'Update',
              url:    '/rocket/edit'
            }
          ]
        end

        include_examples 'should merge the metadata'
      end

      describe 'with a custom action' do
        let(:action_name)   { :launch }
        let(:member_action) { false }
        let(:expected_breadcrumbs) do
          [
            *breadcrumbs,
            {
              active: true,
              label:  'Launch',
              url:    '/rocket/launch'
            }
          ]
        end

        include_examples 'should merge the metadata'
      end

      context 'when initialized with actions: value' do
        let(:actions) do
          {
            show:   [
              {
                label: 'Show',
                url:   ':base_url'
              }
            ],
            launch: [
              {
                label: 'Advanced Actions',
                url:   ':base_url/advanced_actions'
              },
              {
                label: 'Launch',
                url:   ':base_url/advanced_actions/launch'
              }
            ]
          }
        end
        let(:options) { super().merge(actions: actions) }

        describe 'with action_name: :show' do
          let(:action_name)   { :show }
          let(:member_action) { false }
          let(:expected_breadcrumbs) do
            [
              *breadcrumbs,
              {
                active: true,
                label:  'Show',
                url:    '/rocket'
              }
            ]
          end

          include_examples 'should merge the metadata'
        end

        describe 'with a custom action' do
          let(:action_name)   { :launch }
          let(:member_action) { false }
          let(:expected_breadcrumbs) do
            [
              *breadcrumbs,
              {
                label: 'Advanced Actions',
                url:   '/rocket/advanced_actions'
              },
              {
                active: true,
                label:  'Launch',
                url:    '/rocket/advanced_actions/launch'
              }
            ]
          end

          include_examples 'should merge the metadata'
        end
      end
    end
  end
  # rubocop:enable RSpec/MultipleMemoizedHelpers, RSpec/NestedGroups

  describe '#resource' do
    include_examples 'should define reader', :resource, -> { resource }
  end
end
