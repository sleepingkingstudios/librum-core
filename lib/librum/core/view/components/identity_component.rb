# frozen_string_literal: true

require 'view_component'

module Librum::Core::View::Components
  # Component that returns its configuration string when rendered.
  class IdentityComponent < ViewComponent::Base
    # @param contents [String] the HTML to return when rendered.
    def initialize(contents)
      super()

      @contents = sanitize(contents)
    end

    # @return [String] the HTML to return when rendered.
    attr_reader :contents

    # @see ViewComponent::Base#call
    def call
      contents
    end

    private

    def sanitize(raw)
      Loofah
        .html5_fragment(raw)
        .scrub!(:strip)
        .to_s
        .html_safe # rubocop:disable Rails/OutputSafety
    end
  end
end
