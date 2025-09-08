# frozen_string_literal: true

require 'librum/components'
require 'plumbum/consumer'

module Librum::Core::Responders::Html
  # Helper class for finding view components for a controller view.
  class FindView # rubocop:disable Metrics/ClassLength
    include Plumbum::Consumer

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

    APPLICATION_PATTERN = /::Application\z/
    private_constant :APPLICATION_PATTERN

    WHITESPACE_PATTERN = /\s+/
    private_constant :WHITESPACE_PATTERN

    provider Librum::Components.provider

    dependency :components

    # @param application [#view_path] the core application.
    # @param libraries [Array<#view_path>] the libraries used by the application
    #   that may provide views.
    def initialize(application:, libraries: [])
      @application = resolve_application(application)
      @libraries   =
        libraries
        .select { |library| library.respond_to?(:view_path) }
        .map { |library| Library.new(library:) }
      @cache       = {}
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
      action     = convert_to_class_name(action)
      controller = convert_to_class_name(controller)
      cache_key  = "#{controller}::#{action}"

      return cache[cache_key] if cache.key?(cache_key)

      view_paths(action:, controller:).find do |view_path|
        component = cache_component(cache_key) { find_component(view_path) }

        return component if component
      end

      nil
    end

    # Clears the components cache.
    def clear
      @cache = {}
    end

    # @return [Module] the namespace for defined components.
    def components
      unless has_plumbum_dependency?(:components)
        return Librum::Components::Empty
      end

      super
    end

    # @return [Array<#view_path>] the libraries used by the application that
    #   provide views.
    def libraries
      @libraries.map(&:library)
    end

    # Lists the possible view paths for the given action and controller.
    #
    # @param action [String, Symbol] the name of the called action.
    # @param controller [String] the name of the called controller.
    #
    # @return [Array<String>] the possible view paths.
    def view_paths(action:, controller:)
      action         = convert_to_class_name(action)
      controller     = convert_to_class_name(controller)
      library, scope = split_controller(controller)

      [
        application_path(action:, controller:),
        library_path(action:, library:, scope:),
        shared_path(action:, controller:),
        legacy_path(action:, library:, scope:)
      ].compact
    end

    private

    attr_reader :cache

    def application_path(action:, controller:)
      return unless application.respond_to?(:view_path)

      application.view_path(action:, controller:)
    end

    def cache_component(cache_key)
      component = yield

      cache[cache_key] = component if component

      component
    end

    def convert_to_class_name(value)
      value
        .to_s
        .titleize
        .gsub('/', '::')
        .gsub(WHITESPACE_PATTERN, '')
    end

    def find_component(path)
      return nil if path.blank?

      return Object.const_get(path) if Object.const_defined?(path)

      nil
    end

    def legacy_path(action:, library:, scope:)
      path = "View::Pages::#{scope}::#{action}Page"
      path = "#{library.name}::#{path}" if library
      path
    end

    def library_path(action:, library:, scope:)
      library&.view_path(action:, controller: scope)
    end

    def resolve_application(application) # rubocop:disable Metrics/MethodLength
      return application if application.respond_to?(:view_path)

      namespace =
        application
        .class
        .name
        .sub(APPLICATION_PATTERN, '')

      if namespace.present? && Object.const_defined?(namespace)
        namespace = Object.const_get(namespace)

        return namespace if namespace.respond_to?(:view_path)
      end

      application
    end

    def shared_path(action:, controller:)
      return nil unless components&.name
      return nil if components == Librum::Components::Empty

      "#{components.name}::Views::#{controller}::#{action}"
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
