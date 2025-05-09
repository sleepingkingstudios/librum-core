# frozen_string_literal: true

require 'rspec/sleeping_king_studios/contract'

module Librum::Core::RSpec::Contracts
  # :nocov:

  module RoutingContracts
    # Contract asserting the application provides API routes for a resource.
    module ShouldRouteToApiResourceContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |resource_name, singular: false, **rest|
        if singular
          include_contract 'should route to singular api resource',
            resource_name,
            **rest
        else
          include_contract 'should route to plural api resource',
            resource_name,
            **rest
        end
      end
    end

    # Contract asserting the application provides View routes for a resource.
    module ShouldRouteToViewResourceContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |resource_name, singular: false, **rest|
        if singular
          include_contract 'should route to singular view resource',
            resource_name,
            **rest
        else
          include_contract 'should route to plural view resource',
            resource_name,
            **rest
        end
      end
    end

    # @private
    module ShouldRouteToPluralApiResourceContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |resource_name, controller: nil, only: nil, wildcards: {}|
        root_route      = resource_name
        controller_name =
          resource_name
          .to_s
          .split('/')
          .map(&:classify)
          .map(&:pluralize)
          .join('::')
        controller_name =
          "#{controller_name}Controller"
        expected_routes = %i[
          index
          create
          show
          update
          destroy
        ]
        expected_routes &= Array(only).map(&:intern) unless Array(only).empty?

        describe "GET /#{root_route}.json" do
          let(:configured_controller) { controller || root_route }

          if expected_routes.include?(:index)
            it "should route to #{controller_name}#index" do
              expect(get: "/#{root_route}.json").to route_to(
                controller: configured_controller,
                action:     'index',
                format:     'json',
                **wildcards
              )
            end
          else
            it 'should not be routeable' do
              expect(get: "/#{root_route}.json").not_to be_routable
            end
          end
        end

        describe "POST /#{root_route}.json" do
          let(:configured_controller) { controller || root_route }

          if expected_routes.include?(:create)
            it "should route to #{controller_name}#create" do
              expect(post: "/#{root_route}.json").to route_to(
                controller: configured_controller,
                action:     'create',
                format:     'json',
                **wildcards
              )
            end
          else
            it 'should not be routeable' do
              expect(post: "/#{root_route}.json").not_to be_routable
            end
          end
        end

        describe "GET /#{root_route}/:id.json" do
          let(:configured_controller) { controller || root_route }
          let(:configured_resource_id) do
            '00000000-0000-0000-0000-000000000000'
          end

          if expected_routes.include?(:show)
            it "should route to #{controller_name}#show" do
              expect(get: "/#{root_route}/#{configured_resource_id}.json")
                .to route_to(
                  controller: configured_controller,
                  action:     'show',
                  id:         configured_resource_id,
                  format:     'json',
                  **wildcards
                )
            end
          else
            it 'should not be routeable' do
              expect(get: "/#{root_route}/#{resource_id}.json")
                .not_to be_routable
            end
          end
        end

        describe "PATCH /#{root_route}/:id.json" do
          let(:configured_controller) { controller || root_route }
          let(:configured_resource_id) do
            '00000000-0000-0000-0000-000000000000'
          end

          if expected_routes.include?(:update)
            it "should route to #{controller_name}#update" do
              expect(patch: "/#{root_route}/#{configured_resource_id}.json")
                .to route_to(
                  controller: configured_controller,
                  action:     'update',
                  id:         configured_resource_id,
                  format:     'json',
                  **wildcards
                )
            end
          else
            it 'should not be routeable' do
              expect(patch: "/#{root_route}/#{resource_id}.json")
                .not_to be_routable
            end
          end
        end

        describe "DELETE /#{root_route}/:id.json" do
          let(:configured_controller) { controller || root_route }
          let(:configured_resource_id) do
            '00000000-0000-0000-0000-000000000000'
          end

          if expected_routes.include?(:destroy)
            it "should route to #{controller_name}#destroy" do
              expect(delete: "/#{root_route}/#{configured_resource_id}.json")
                .to route_to(
                  controller: configured_controller,
                  action:     'destroy',
                  id:         configured_resource_id,
                  format:     'json',
                  **wildcards
                )
            end
          else
            it 'should not be routeable' do
              expect(delete: "/#{root_route}/#{resource_id}.json")
                .not_to be_routable
            end
          end
        end
      end
    end

    # @private
    module ShouldRouteToPluralViewResourceContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |resource_name, controller: nil, only: nil, wildcards: {}|
        root_route      = resource_name
        controller_name =
          resource_name
          .to_s
          .split('/')
          .map(&:classify)
          .map(&:pluralize)
          .join('::')
        controller_name =
          "#{controller_name}Controller"
        expected_routes = %i[
          index
          create
          edit
          new
          show
          update
          destroy
        ]
        expected_routes &= Array(only).map(&:intern) unless Array(only).empty?

        describe "GET /#{root_route}.html" do
          let(:configured_controller) { controller || root_route }

          if expected_routes.include?(:index)
            it "should route to #{controller_name}#index" do
              expect(get: "/#{root_route}.html").to route_to(
                controller: configured_controller,
                action:     'index',
                format:     'html',
                **wildcards
              )
            end
          end
        end

        describe "POST /#{root_route}.html" do
          let(:configured_controller) { controller || root_route }

          if expected_routes.include?(:create)
            it "should route to #{controller_name}#create" do
              expect(post: "/#{root_route}.html").to route_to(
                controller: configured_controller,
                action:     'create',
                format:     'html',
                **wildcards
              )
            end
          else
            it 'should not be routeable' do
              expect(post: "/#{root_route}.html").not_to be_routable
            end
          end
        end

        describe "GET /#{root_route}/new.html" do
          let(:configured_controller) { controller || root_route }

          if expected_routes.include?(:new)
            it "should route to #{controller_name}#new" do
              expect(get: "/#{root_route}/new.html").to route_to(
                controller: configured_controller,
                action:     'new',
                format:     'html',
                **wildcards
              )
            end
          end
        end

        describe "GET /#{root_route}/:id" do
          let(:configured_controller) { controller || root_route }
          let(:configured_resource_id) do
            '00000000-0000-0000-0000-000000000000'
          end

          if expected_routes.include?(:show)
            it "should route to #{controller_name}#show" do
              expect(get: "/#{root_route}/#{configured_resource_id}.html")
                .to route_to(
                  controller: configured_controller,
                  action:     'show',
                  id:         configured_resource_id,
                  format:     'html',
                  **wildcards
                )
            end
          end
        end

        describe "PATCH /#{root_route}/:id" do
          let(:configured_controller) { controller || root_route }
          let(:configured_resource_id) do
            '00000000-0000-0000-0000-000000000000'
          end

          if expected_routes.include?(:update)
            it "should route to #{controller_name}#update" do
              expect(patch: "/#{root_route}/#{configured_resource_id}.html")
                .to route_to(
                  controller: configured_controller,
                  action:     'update',
                  id:         configured_resource_id,
                  format:     'html',
                  **wildcards
                )
            end
          else
            it 'should not be routeable' do
              expect(patch: "/#{root_route}/#{configured_resource_id}.html")
                .not_to be_routable
            end
          end
        end

        describe "DELETE /#{root_route}/:id" do
          let(:configured_controller) { controller || root_route }
          let(:configured_resource_id) do
            '00000000-0000-0000-0000-000000000000'
          end

          if expected_routes.include?(:destroy)
            it "should route to #{controller_name}#destroy" do
              expect(delete: "/#{root_route}/#{configured_resource_id}.html")
                .to route_to(
                  controller: configured_controller,
                  action:     'destroy',
                  id:         configured_resource_id,
                  format:     'html',
                  **wildcards
                )
            end
          else
            it 'should not be routeable' do
              expect(delete: "/#{root_route}/#{configured_resource_id}.html")
                .not_to be_routable
            end
          end
        end

        describe "GET /#{root_route}/:id/edit" do
          let(:configured_controller) { controller || root_route }
          let(:configured_resource_id) do
            '00000000-0000-0000-0000-000000000000'
          end

          if expected_routes.include?(:edit)
            it "should route to #{controller_name}#edit" do
              expect(get: "/#{root_route}/#{configured_resource_id}/edit.html")
                .to route_to(
                  controller: configured_controller,
                  action:     'edit',
                  id:         configured_resource_id,
                  format:     'html',
                  **wildcards
                )
            end
          end
        end
      end
    end

    # @private
    module ShouldRouteToSingularApiResourceContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |resource_name, controller: nil, only: nil, wildcards: {}|
        root_route      = resource_name
        controller_name =
          resource_name
          .to_s
          .split('/')
          .map(&:classify)
          .map(&:pluralize)
          .join('::')
        controller_name =
          "#{controller_name}Controller"
        expected_routes = %i[
          create
          show
          update
          destroy
        ]
        expected_routes &= Array(only).map(&:intern) unless Array(only).empty?

        describe "GET /#{root_route}.json" do
          let(:configured_controller) { controller || root_route.pluralize }

          if expected_routes.include?(:show)
            it "should route to #{controller_name}#show" do
              expect(get: "/#{root_route}.json").to route_to(
                controller: configured_controller,
                action:     'show',
                format:     'json',
                **wildcards
              )
            end
          else
            it 'should not be routeable' do
              expect(get: "/#{root_route}.json").not_to be_routable
            end
          end
        end

        describe "POST /#{root_route}.json" do
          let(:configured_controller) { controller || root_route.pluralize }

          if expected_routes.include?(:create)
            it "should route to #{controller_name}#create" do
              expect(post: "/#{root_route}.json").to route_to(
                controller: configured_controller,
                action:     'create',
                format:     'json',
                **wildcards
              )
            end
          else
            it 'should not be routeable' do
              expect(post: "/#{root_route}.json").not_to be_routable
            end
          end
        end

        describe "PATCH /#{root_route}.json" do
          let(:configured_controller) { controller || root_route.pluralize }

          if expected_routes.include?(:update)
            it "should route to #{controller_name}#update" do
              expect(patch: "/#{root_route}.json")
                .to route_to(
                  controller: configured_controller,
                  action:     'update',
                  format:     'json',
                  **wildcards
                )
            end
          else
            it 'should not be routeable' do
              expect(patch: "/#{root_route}.json")
                .not_to be_routable
            end
          end
        end

        describe "DELETE /#{root_route}.json" do
          let(:configured_controller) { controller || root_route.pluralize }

          if expected_routes.include?(:destroy)
            it "should route to #{controller_name}#destroy" do
              expect(delete: "/#{root_route}.json")
                .to route_to(
                  controller: configured_controller,
                  action:     'destroy',
                  format:     'json',
                  **wildcards
                )
            end
          else
            it 'should not be routeable' do
              expect(delete: "/#{root_route}.json")
                .not_to be_routable
            end
          end
        end
      end
    end

    # @private
    module ShouldRouteToSingularViewResourceContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |resource_name, controller: nil, only: nil, wildcards: {}|
        root_route      = resource_name
        controller_name =
          resource_name
          .to_s
          .split('/')
          .map(&:classify)
          .map(&:pluralize)
          .join('::')
        controller_name =
          "Api::#{controller_name}Controller"
        expected_routes = %i[
          create
          edit
          new
          show
          update
          destroy
        ]
        expected_routes &= Array(only).map(&:intern) unless Array(only).empty?

        describe "GET /#{root_route}.html" do
          let(:configured_controller) { controller || root_route.pluralize }

          if expected_routes.include?(:show)
            it "should route to #{controller_name}#show" do
              expect(get: "/#{root_route}.html").to route_to(
                controller: configured_controller,
                action:     'show',
                format:     'html',
                **wildcards
              )
            end
          end
        end

        describe "POST /#{root_route}.html" do
          let(:configured_controller) { controller || root_route.pluralize }

          if expected_routes.include?(:create)
            it "should route to #{controller_name}#create" do
              expect(post: "/#{root_route}.html").to route_to(
                controller: configured_controller,
                action:     'create',
                format:     'html',
                **wildcards
              )
            end
          else
            it 'should not be routeable' do
              expect(post: "/#{root_route}.html").not_to be_routable
            end
          end
        end

        describe "PATCH /#{root_route}.html" do
          let(:configured_controller) { controller || root_route.pluralize }

          if expected_routes.include?(:update)
            it "should route to #{controller_name}#update" do
              expect(patch: "/#{root_route}.html")
                .to route_to(
                  controller: configured_controller,
                  action:     'update',
                  format:     'html',
                  **wildcards
                )
            end
          else
            it 'should not be routeable' do
              expect(patch: "/#{root_route}.html")
                .not_to be_routable
            end
          end
        end

        describe "DELETE /#{root_route}.html" do
          let(:configured_controller) { controller || root_route.pluralize }

          if expected_routes.include?(:destroy)
            it "should route to #{controller_name}#destroy" do
              expect(delete: "/#{root_route}.html")
                .to route_to(
                  controller: configured_controller,
                  action:     'destroy',
                  format:     'html',
                  **wildcards
                )
            end
          else
            it 'should not be routeable' do
              expect(delete: "/#{root_route}.html")
                .not_to be_routable
            end
          end
        end

        describe "GET /#{root_route}/edit.html" do
          let(:configured_controller) { controller || root_route.pluralize }

          if expected_routes.include?(:edit)
            it "should route to #{controller_name}#edit" do
              expect(get: "/#{root_route}/edit.html").to route_to(
                controller: configured_controller,
                action:     'edit',
                format:     'html',
                **wildcards
              )
            end
          end
        end

        describe "GET /#{root_route}/new.html" do
          let(:configured_controller) { controller || root_route.pluralize }

          if expected_routes.include?(:new)
            it "should route to #{controller_name}#new" do
              expect(get: "/#{root_route}/new.html").to route_to(
                controller: configured_controller,
                action:     'new',
                format:     'html',
                **wildcards
              )
            end
          end
        end
      end
    end
  end
  # :nocov:
end
