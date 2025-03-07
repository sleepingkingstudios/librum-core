# frozen_string_literal: true

module Librum::Core::Actions::View::Middleware
  # Middleware for configuring a resourceful controller page's breadcrumbs.
  class ResourceBreadcrumbs < # rubocop:disable Metrics/ClassLength
        Librum::Core::Actions::View::Middleware::PageBreadcrumbs
    extend Forwardable

    # @param actions [Hash{Symbol => Array<
    #   View::Layouts::Page::Breadcrumbs::BreadcrumbConfiguration>}] the
    #   additional breadcrumbs configured for actions.
    # @param breadcrumbs
    #   [Array<View::Layouts::Page::Breadcrumbs::BreadcrumbConfiguration>] the
    #   base breadcrumbs to render.
    # @param resource [Cuprum::Rails::Resource] the resource for the controller.
    # @param options [Hash{Symbol=>Object}] additional options for configuring
    #   the view page.
    def initialize(breadcrumbs:, resource:, actions: {}, **options)
      super(breadcrumbs: breadcrumbs, **options)

      @resource = resource
      @actions  = generate_actions.merge(actions)
    end

    def_delegators :@request,
      :action_name

    # @return [Hash{Symbol => Array<
    #   View::Layouts::Page::Breadcrumbs::BreadcrumbConfiguration>}] the
    #   additional breadcrumbs configured for actions.
    attr_reader :actions

    # @return [Cuprum::Rails::Resource] the resource for the controller.
    attr_reader :resource

    private

    def apply_base_url_wildcard(url)
      url.gsub(':base_url', base_url)
    end

    def apply_name_wildcard(label)
      return label unless label.include?(':name')

      unless resource_data && resource_data['name'].present?
        return resource.singular_name.titleize
      end

      label.gsub(':name', resource_data['name'])
    end

    def apply_params_wildcards(url)
      (request.path_params || {}).reduce(url) do |str, (key, value)|
        wildcard = ":#{key}"

        next str unless str.include?(wildcard)

        str.gsub(wildcard, value.to_s)
      end
    end

    def apply_slug_wildcard(url)
      return url unless url.include?(':slug')

      return base_url unless resource_data && resource_data['slug'].present?

      url.gsub(':slug', resource_data['slug'])
    end

    def apply_wildcards(breadcrumbs)
      breadcrumbs.map do |breadcrumb|
        label = breadcrumb[:label].then { |str| apply_name_wildcard(str) }
        url   =
          breadcrumb[:url]
          .then { |str| apply_base_url_wildcard(str) }
          .then { |str| apply_slug_wildcard(str) }
          .then { |str| apply_params_wildcards(str) }

        breadcrumb.merge(label: label, url: url)
      end
    end

    def base_url
      breadcrumbs.last[:url]
    end

    def generate_action_breadcrumbs
      return actions[action_name.intern] if actions.key?(action_name.intern)

      if request.member_action?
        generate_member_action
      else
        generate_collection_action
      end
    end

    def generate_actions
      if resource.plural?
        generate_plural_actions
      else
        generate_singular_actions
      end
    end

    def generate_breadcrumbs
      [*breadcrumbs, *generate_action_breadcrumbs]
        .then { |ary| apply_wildcards(ary) }
        .then { |ary| mark_as_active(ary) }
    end

    def generate_collection_action
      [
        {
          label: action_name.to_s.titleize,
          url:   "#{base_url}/#{action_name.to_s.underscore}"
        }
      ]
    end

    def generate_member_action
      [
        {
          label: ':name',
          url:   "#{base_url}/:slug"
        },
        {
          label: action_name.to_s.titleize,
          url:   "#{base_url}/:slug/#{action_name.to_s.underscore}"
        }
      ]
    end

    def generate_plural_actions # rubocop:disable Metrics/MethodLength
      new_breadcrumbs  = [{ label: 'Create', url: "#{base_url}/new" }]
      edit_breadcrumbs = [
        { label: ':name', url: "#{base_url}/:slug" },
        { label: 'Update', url: "#{base_url}/:slug/edit" }
      ]

      {
        create: new_breadcrumbs,
        edit:   edit_breadcrumbs,
        index:  [],
        new:    new_breadcrumbs,
        show:   [{ label: ':name', url: "#{base_url}/:slug" }],
        update: edit_breadcrumbs
      }
    end

    def generate_singular_actions
      new_breadcrumbs  = [{ label: 'Create', url: "#{base_url}/new" }]
      edit_breadcrumbs = [{ label: 'Update', url: "#{base_url}/edit" }]

      {
        create: new_breadcrumbs,
        edit:   edit_breadcrumbs,
        new:    new_breadcrumbs,
        show:   [],
        update: edit_breadcrumbs
      }
    end

    def mark_as_active(breadcrumbs)
      *rest, last = breadcrumbs

      [*rest, last.merge(active: true)]
    end

    def page_metadata
      super.merge(breadcrumbs: generate_breadcrumbs)
    end

    def resource_data
      return nil unless result.value.is_a?(Hash)

      result.value[resource.singular_name]
    end
  end
end
