# frozen_string_literal: true

module MdToNotion
  module Block
    def self.heading_1(texts)
      {
        type: "heading_1",
        heading_1: {
          rich_text: texts.map { |t| rich_text(t) }
        }
      }
    end

    def self.heading_2(texts)
      {
        type: "heading_2",
        heading_2: {
          rich_text: texts.map { |t| rich_text(t) }
        }
      }
    end

    def self.heading_3(texts)
      {
        type: "heading_3",
        heading_3: {
          rich_text: texts.map { |t| rich_text(t) }
        }
      }
    end

    def self.paragraph(texts, children: nil)
      block = {
        type: "paragraph",
        paragraph: {
          rich_text: texts.map { |t| rich_text(t) }
        }
      }

      block[:paragraph][:children] = children if children
      block
    end

    def self.quote(texts, children: nil)
      block = {
        type: "quote",
        quote: {
          rich_text: texts.map { |t| rich_text(t) }
        }
      }

      block[:quote][:children] = children if children
      block
    end

    def self.code(text, lang: nil)
      {
        type: "code",
        code: {
          rich_text: [rich_text({ text: text })],
          language: lang
        }
      }
    end

    def self.bulleted_list_item(texts, children: nil)
      block = {
        type: "bulleted_list_item",
        bulleted_list_item: {
          rich_text: texts.map { |t| rich_text(t) }
        }
      }

      block[:bulleted_list_item][:children] = children if children
      block
    end

    def self.numbered_list(texts, children: nil)
      block = {
        type: "numbered_list_item",
        numbered_list_item: {
          rich_text: texts.map { |t| rich_text(t) }
        }
      }

      block[:numbered_list_item][:children] = children if children
      block
    end

    def self.image
      {
        type: "image",
        image: {
          type: "external",
          external: {
            url: link
          }
        }
      }
    end

    def self.rich_text(token, annotations: {}, href: nil, link: nil)
      default_annotations = {
        bold: token[:type] == :bold,
        italic: token[:type] == :italic,
        strikethrough: token[:type] == :strikethrough,
        underline: token[:type] == :underline,
        code: token[:type] == :code
      }

      {
        type: "text",
        text: {
          content: token[:text],
          link: link
        },
        annotations: default_annotations.merge(annotations),
        href: href
      }
    end
  end
end
