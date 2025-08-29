# frozen_string_literal: true

module Librum::Core::Responders::Html
  # Helper class for finding view components for a controller view.
  class FindView
    Library = Data.define(:library, :name) do
      delegate :view_path, to: :library

      def initialize(library:)
        name = library.name.sub(/(Engine|Railtie)\z/, '')

        super(library:, name:)
      end

      def match?(controller)
        controller.start_with?(name)
      end
    end
    private_constant :Library

    # @param application [#view_path] the core application.
    # @param libraries [Array<#view_path>] the libraries used by the application
    #   that may provide views.
    def initialize(application:, libraries: [])
      @application = application
      @libraries   =
        libraries
        .select { |library| library.respond_to?(:view_path) }
        .map { |library| Library.new(library:) }
      @components  = {}
    end

    # @return [#view_path] the core application.
    attr_reader :application

    # Finds the requested view component class for an action.
    #
    # @param action [String, Symbol] the name of the called action.
    # @param controller [String] the name of the called controller.
    #
    # @return [Class, nil] the matched class, or nil if no component class is
    #   found.
    def call(action:, controller:)
      action     = modulize(action)
      controller = modulize(controller)
      cache_key  = "#{controller}::#{action}"

      return components[cache_key] if components.key?(cache_key)

      library, scope = split_controller(controller)

      find_application_component(action:, cache_key:, controller:) ||
        find_library_component(action:, cache_key:, library:, scope:) ||
        find_legacy_component(action:, cache_key:, library:, scope:)
    end

    # Clears the components cache.
    def clear
      @components = {}
    end

    # @return [Array<#view_path>] the libraries used by the application that
    #   provide views.
    def libraries
      @libraries.map(&:library)
    end

    private

    attr_reader :components

    def find_application_component(action:, cache_key:, controller:)
      return unless application.respond_to?(:view_path)

      path      = application.view_path(action:, controller:)
      component = find_component(path)

      components[cache_key] = component if component
    end

    def find_legacy_component(action:, cache_key:, library:, scope:)
      path      = "View::Pages::#{scope}::#{action}Page"
      path      = "#{library.name}::#{path}" if library
      component = find_component(path)

      components[cache_key] = component if component
    end

    def find_library_component(action:, cache_key:, library:, scope:)
      return unless library

      path      = library.view_path(action:, controller: scope)
      component = find_component(path)

      components[cache_key] = component if component
    end

    def find_component(path)
      return Object.const_get(path) if Object.const_defined?(path)

      nil
    end

    def modulize(value)
      value.titleize.gsub('/', '::')
    end

    def split_controller(controller)
      @libraries.each do |library|
        next unless library.match?(controller)

        scope_name =
          controller
          .sub(/\A#{library.name}::/, '')
          .sub(/Controller\z/, '')

        return [library, scope_name]
      end

      [nil, controller]
    end
  end
end
