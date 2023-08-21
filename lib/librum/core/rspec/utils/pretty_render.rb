# frozen_string_literal: true

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

    def authenticity_token?(tag)
      return false unless tag.name == 'input'

      tag.attributes['name'].value == 'authenticity_token'
    end

    def child_tags(tag)
      tag
        .children
        .reject { |child| child.text? && child.to_s =~ /\A\s*\z/ }
    end

    def closing_tag(tag)
      "</#{tag.name}>"
    end

    def format_attributes(tag)
      tag
        .attributes
        .each_value
        .map { |attribute| %(#{attribute.name}="#{attribute.value}") }
        .join(' ')
    end

    def has_children?(tag) # rubocop:disable Naming/PredicateName
      tag.children.any?(&:element?)
    end

    def has_text?(tag) # rubocop:disable Naming/PredicateName
      tag.children.any?(&:text?)
    end

    def indent(str)
      str
        .lines
        .map { |line| line.start_with?("\n") ? line : "  #{line}" }
        .join
    end

    def join_text(tag)
      tag
        .children
        .select(&:text?)
        .map(&:to_s)
        .join
    end

    def opening_tag(tag)
      return "<#{tag.name}>" if tag.attributes.empty?

      "<#{tag.name} #{format_attributes(tag)}>"
    end

    def realign_text(text)
      match = text.match(/\n( +)\z/)

      return text unless match

      offset = match[1].size

      text.each_line.map { |line| line.sub(/\A#{' ' * offset}/, '') }.join
    end

    def render_authenticity_token
      %(<input type="hidden" name="authenticity_token" value="[token]" ) \
        'autocomplete="off">'
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
      return render_tag_with_children(tag) if has_children?(tag)
      return render_tag_with_text(tag)     if has_text?(tag)
      return render_authenticity_token     if authenticity_token?(tag)

      tag.to_s.strip
    end

    def render_tag_with_children(tag)
      buffer = +''
      buffer << opening_tag(tag) << "\n"
      buffer << indent(render_children(tag))
      buffer << closing_tag(tag)
    end

    def render_tag_with_text(tag)
      buffer = +''
      buffer << opening_tag(tag)
      buffer << render_text(tag)
      buffer << closing_tag(tag)
    end

    def render_text(tag)
      text = join_text(tag)

      return text unless text.include?("\n")

      # Aligns the text content with the closing tag.
      text = realign_text(text)

      # Remove extra whitespace from empty lines.
      text = text.gsub(/^\n\s+$/, "\n")

      # Trim leading and trailing newlines
      text.sub(/\A\n+/, "\n").sub(/\n+\z/, "\n")
    end
  end
end
