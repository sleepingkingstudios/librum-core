# frozen_string_literal: true

require 'view_component/test_helpers'

require 'librum/core/rspec'
require 'librum/core/rspec/matchers'
require 'librum/core/rspec/utils/pretty_render'

module Librum::Core::RSpec
  # Helper methods for testing view components.
  module ComponentHelpers
    include ViewComponent::TestHelpers
    include Librum::Core::RSpec::Matchers

    # Generates a standardized representation of the component.
    #
    # @param document [Nokogiri::XML::Node] the document or tag to render.
    #
    # @return [String] the rendered HTML.
    def pretty_render(component)
      Librum::Core::RSpec::Utils::PrettyRender.new.call(component)
    end
  end
end
