# frozen_string_literal: true

require 'librum/core/rspec/utils'

module Librum::Core::RSpec::Utils
  # Utility class for rendering HTML documents with a consistent format.
  class PrettyRender
    # @param document [Nokogiri::XML::Node] the document or tag to render.
    #
    # @return [String] the rendered HTML.
    def call(document)
      render_children(document)
    end

    private

    def child_tags(tag)
      tag
        .children
        .reject { |child| child.text? && child.to_s =~ /\A\s*\z/ }
    end

    def closing_tag(tag)
      "</#{tag.name}>"
    end

    def has_children?(tag) # rubocop:disable Naming/PredicateName
      tag.children.any?(&:element?)
    end

    def indent(str)
      str
        .lines
        .map { |line| line.start_with?("\n") ? line : "  #{line}" }
        .join
    end

    def opening_tag(tag)
      "<#{tag.name}>"
    end

    def render_children(tag)
      buffer = +''

      child_tags(tag).each.with_index.map do |child, index|
        buffer << "\n\n" unless index.zero?

        buffer << render_tag(child)
      end

      buffer << "\n"
    end

    def render_tag(tag)
      return tag.to_s.strip unless has_children?(tag)

      buffer = +''
      buffer << opening_tag(tag) << "\n"
      buffer << indent(render_children(tag))
      buffer << closing_tag(tag)
    end
  end
end
