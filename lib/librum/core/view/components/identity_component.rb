# frozen_string_literal: true

require 'view_component'

require 'librum/core/view/components'

module Librum::Core::View::Components
  # Component that returns its configuration string when rendered.
  class IdentityComponent < ViewComponent::Base
    # @param contents [String] the HTML to return when rendered.
    def initialize(contents)
      super()

      @contents = contents
    end

    # @return [String] the HTML to return when rendered.
    attr_reader :contents

    # @see ViewComponent::Base#call
    def call
      contents
    end
  end
end
