# frozen_string_literal: true

module Librum::Core::View
  # Concern for defining a :class_name option for a component.
  module ClassName
    include Librum::Core::View::Options

    # @return [Array<String>] additional CSS class names for the icon.
    def class_name
      Array(@options.fetch(:class_name, []))
    end
  end
end
