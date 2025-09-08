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

    # @return [Symbol] the format of the responder.
    def format
      :html
    end

    private

    def build_missing_page(action_name:, controller_name:, result:)
      component ||= find_component_class('Views::MissingView')
      component ||= Librum::Core::View::Pages::MissingPage

      expected_page =
        convert_to_class_name("#{controller_name}::#{action_name}")

      component.new(result, action_name:, controller_name:, expected_page:)
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
  end
end
