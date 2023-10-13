# frozen_string_literal: true

module Librum::Core::View
  # Concern for defining arbitrary options for a component.
  module Options
    extend ActiveSupport::Concern

    class_methods do # rubocop:disable Metrics/BlockLength
      def option(option_name, boolean: false, default: nil)
        option_name  = option_name.to_s.sub(/\?\z/, '').intern
        default_proc = default_proc_for(default)

        if boolean
          define_predicate(option_name, default_proc)
        else
          define_reader(option_name, default_proc)
        end
      end

      private

      def default_proc_for(default)
        return if default.nil?

        return default if default.is_a?(Proc)

        -> { default }
      end

      def define_predicate(option_name, default)
        method_name = "#{option_name}?"

        if default
          define_method(method_name) do
            !!@options.fetch(option_name) { instance_exec(&default) }
          end
        else
          define_method(method_name) do
            !!@options[option_name]
          end
        end
      end

      def define_reader(option_name, default)
        if default
          define_method(option_name) do
            @options.fetch(option_name) { instance_exec(&default) }
          end
        else
          define_method(option_name) do
            @options[option_name]
          end
        end
      end
    end

    # @param options [Hash] additional options for the component.
    def initialize(**options)
      super()

      @options = options
    end

    # @return [Hash] additional options for the component.
    attr_reader :options
  end
end
