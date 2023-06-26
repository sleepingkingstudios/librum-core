# frozen_string_literal: true

require 'view_component/test_helpers'

require 'rspec/sleeping_king_studios/concerns/shared_example_group'

require 'librum/core/rspec'
require 'librum/core/rspec/matchers'
require 'librum/core/rspec/utils/pretty_render'
require 'librum/core/view/components/mock_component'

module Librum::Core::RSpec
  # Helper methods for testing view components.
  module ComponentHelpers
    include ViewComponent::TestHelpers
    include Librum::Core::RSpec::Matchers

    # Shared examples for testing view components.
    module ComponentExamples
      extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

      shared_context 'with mock component' do |component_name|
        class_name = "Spec::#{component_name.camelize}Component"

        let(:"#{component_name}_component") { class_name.constantize }

        example_class class_name,
          Librum::Core::View::Components::MockComponent \
        do |klass|
          name = component_name

          klass.define_method(:initialize) do |**options|
            super(name, **options)
          end
        end
      end
    end

    class << self
      private

      def included(other)
        super

        other.include(ComponentExamples)
      end
    end

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
