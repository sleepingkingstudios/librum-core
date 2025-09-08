# frozen_string_literal: true

require 'cuprum/rails/responses/html/redirect_response'
require 'cuprum/rails/responders/actions'
require 'cuprum/rails/responders/base_responder'
require 'cuprum/rails/responders/matching'

module Librum::Core::Responders::Html
  # Provides a DSL for defining responses to HTML requests.
  class ViewResponder < Cuprum::Rails::Responders::BaseResponder
    include Cuprum::Rails::Responders::Matching
    include Cuprum::Rails::Responders::Actions
    include Librum::Core::Responders::Html::Rendering

    match :success do |result|
      render_component(result)
    end

    match :failure do
      render_component(result, status: :internal_server_error)
    end

    # @!method call(result)
    #   (see Cuprum::Rails::Responders::Actions#call)
    def call(result)
      result = merge_metadata(result)

      super
    end

    # @return [Symbol] the format of the responder.
    def format
      :html
    end

    private

    def build_missing_page(action_name:, controller_name:, result:) # rubocop:disable Metrics/MethodLength
      component ||= find_component_class('Views::MissingView')
      component ||= Librum::Core::View::Pages::MissingPage

      expected_page =
        convert_to_class_name("#{controller_name}::#{action_name}")

      build_component(
        component,
        result,
        action_name:     controller_name.to_s,
        controller_name: controller_name.to_s,
        expected_page:,
        view_paths:      view_paths_for(action_name:, controller_name:)
      )
    end

    def controller_metadata
      {
        'action_name'     => action_name,
        'controller_name' => controller_name,
        'member_action'   => member_action?
      }
    end

    def handle_missing_component( # rubocop:disable Metrics/ParameterLists
      action_name:,
      controller_name:,
      flash:,
      layout:,
      result:,
      **
    )
      component = build_missing_page(action_name:, controller_name:, result:)
      status    = :internal_server_error

      build_response(component, flash:, layout:, result:, status:)
    end

    def merge_metadata(result)
      return result unless result.is_a?(Cuprum::Rails::Result)

      Cuprum::Rails::Result.new(
        **result.properties,
        metadata: controller_metadata.merge(result.metadata || {})
      )
    end

    def view_paths_for(action_name:, controller_name:)
      self.class.find_view.view_paths(
        action:     action_name,
        controller: controller_name
      )
    end
  end
end
