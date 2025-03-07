# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders a navigation tab item.
  class Tabs::Item < ViewComponent::Base
    # @param tab [Librum::Core::View::Components::Tabs::TabDefinition] the tab
    #   to render.
    # @param active [Boolean] if true, renders the tab as active. Defaults to
    #   false.
    def initialize(tab:, active: false)
      super()

      @tab    = tab
      @active = active
    end

    # @return [Librum::Core::View::Components::Tabs::TabDefinition] the tab to
    #   render.
    attr_reader :tab

    # @return [Boolean] if true, renders the tab as active.
    def active?
      @active
    end

    private

    def build_link
      Librum::Core::View::Components::Link.new(
        tab.url,
        class_name: tab.class_name,
        color:      tab.color,
        label:      tab.label,
        icon:       tab.icon
      )
    end

    def link_class_name
      class_names = []

      class_names << tab.class_name if tab.class_name.present?

      class_names << "has-text-#{tab.color}" if tab.color.present?

      class_names.join(' ')
    end

    def render_contents
      return render(build_link) if tab.link?

      class_name = link_class_name
      options    = class_name.present? ? { class: class_name } : {}

      tag.a(**options) { render_text }
    end

    def render_text
      return tab.label unless tab.icon?

      render(
        Librum::Core::View::Components::IconText.new(
          contents: tab.label,
          icon:     tab.icon
        )
      )
    end

    def render_wrapper(&)
      options = active? ? { class: 'is-active' } : {}

      tag.li(**options, &)
    end
  end
end
