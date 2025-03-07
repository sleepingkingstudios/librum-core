# frozen_string_literal: true

module Librum::Core::Resources
  # Resource class for configuring Librum::Core view controllers.
  class ViewResource < Librum::Core::Resources::BaseResource
    # @param block_component [Class] the view component class for rendering the
    #   :show action for the resource.
    # @param form_component [Class] the view component class for rendering the
    #   :create and :update actions for the resource.
    # @param table_component [Class] the view component class for rendering the
    #   :index action for the resource.
    # @param options [Hash<Symbol>] the default options for a resource.
    def initialize(
      block_component: nil,
      form_component:  nil,
      table_component: nil,
      **
    )
      super(**)

      @block_component = block_component
      @form_component  = form_component
      @table_component = table_component
    end

    # @return [Class] the view component class for rendering the :show action
    #   for the resource.
    attr_reader :block_component

    # @return [Class] the view component class for rendering the :create and
    #   :update actions for the resource.
    attr_reader :form_component

    # @return [Class] the view component class for rendering the :index action
    #   for the resource.
    attr_reader :table_component
  end
end
