# frozen_string_literal: true

require 'rspec/sleeping_king_studios/contract'

require 'librum/core/rspec/contracts'

module Librum::Core::RSpec::Contracts
  module RoutingContracts
    # Contract asserting the application provides API routes for a resource.
    module ShouldRouteToApiResourceContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |resource_name, controller: nil, only: nil, singular: false|
        if singular
          include_contract 'should route to singular api resource',
            resource_name,
            controller: controller,
            only:       only
        else
          include_contract 'should route to plural api resource',
            resource_name,
            controller: controller,
            only:       only
        end
      end
    end

    # @private
    module ShouldRouteToPluralApiResourceContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |resource_name, controller: nil, only: nil|
        root_route      = "api/#{resource_name}"
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
          index
          create
          show
          update
          destroy
        ]
        expected_routes &= Array(only).map(&:intern) unless Array(only).empty?

        describe "GET /#{root_route}" do
          let(:configured_controller) { controller || root_route }

          if expected_routes.include?(:index)
            it "should route to #{controller_name}#index" do
              expect(get: "/#{root_route}.json").to route_to(
                controller: configured_controller,
                action:     'index',
                format:     'json'
              )
            end
          else
            it 'should not be routeable' do
              expect(get: "/#{root_route}.json").not_to be_routable
            end
          end
        end

        describe "POST /#{root_route}" do
          let(:configured_controller) { controller || root_route }

          if expected_routes.include?(:create)
            it "should route to #{controller_name}#create" do
              expect(post: "/#{root_route}.json").to route_to(
                controller: configured_controller,
                action:     'create',
                format:     'json'
              )
            end
          else
            it 'should not be routeable' do
              expect(post: "/#{root_route}.json").not_to be_routable
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
              expect(get: "/#{root_route}/#{configured_resource_id}.json")
                .to route_to(
                  controller: configured_controller,
                  action:     'show',
                  id:         configured_resource_id,
                  format:     'json'
                )
            end
          else
            it 'should not be routeable' do
              expect(get: "/#{root_route}/#{resource_id}.json")
                .not_to be_routable
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
              expect(patch: "/#{root_route}/#{configured_resource_id}.json")
                .to route_to(
                  controller: configured_controller,
                  action:     'update',
                  id:         configured_resource_id,
                  format:     'json'
                )
            end
          else
            it 'should not be routeable' do
              expect(patch: "/#{root_route}/#{resource_id}.json")
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
              expect(delete: "/#{root_route}/#{configured_resource_id}.json")
                .to route_to(
                  controller: configured_controller,
                  action:     'destroy',
                  id:         configured_resource_id,
                  format:     'json'
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
    module ShouldRouteToSingularApiResourceContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |resource_name, controller: nil, only: nil|
        root_route      = "api/#{resource_name}"
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
          show
          update
          destroy
        ]
        expected_routes &= Array(only).map(&:intern) unless Array(only).empty?

        describe "GET /#{root_route}" do
          let(:configured_controller) { controller || root_route.pluralize }

          if expected_routes.include?(:show)
            it "should route to #{controller_name}#show" do
              expect(get: "/#{root_route}.json").to route_to(
                controller: configured_controller,
                action:     'show',
                format:     'json'
              )
            end
          else
            it 'should not be routeable' do
              expect(get: "/#{root_route}.json").not_to be_routable
            end
          end
        end

        describe "POST /#{root_route}" do
          let(:configured_controller) { controller || root_route.pluralize }

          if expected_routes.include?(:create)
            it "should route to #{controller_name}#create" do
              expect(post: "/#{root_route}.json").to route_to(
                controller: configured_controller,
                action:     'create',
                format:     'json'
              )
            end
          else
            it 'should not be routeable' do
              expect(post: "/#{root_route}.json").not_to be_routable
            end
          end
        end

        describe "PATCH /#{root_route}" do
          let(:configured_controller) { controller || root_route.pluralize }

          if expected_routes.include?(:update)
            it "should route to #{controller_name}#update" do
              expect(patch: "/#{root_route}.json")
                .to route_to(
                  controller: configured_controller,
                  action:     'update',
                  format:     'json'
                )
            end
          else
            it 'should not be routeable' do
              expect(patch: "/#{root_route}.json")
                .not_to be_routable
            end
          end
        end

        describe "DELETE /#{root_route}" do
          let(:configured_controller) { controller || root_route.pluralize }

          if expected_routes.include?(:destroy)
            it "should route to #{controller_name}#destroy" do
              expect(delete: "/#{root_route}.json")
                .to route_to(
                  controller: configured_controller,
                  action:     'destroy',
                  format:     'json'
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
  end
end
