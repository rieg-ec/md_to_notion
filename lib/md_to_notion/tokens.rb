module MdToNotion
  module Tokens
    HEADING_1 = /^# (.+)/
    HEADING_2 = /^## (.+)/
    HEADING_3 = /^### (.+)/
    CODE_BLOCK = /^```(?:[^\n]+\n)?(.+?)\n```$/m
    BULLET_LIST = /^- (.+)/
    NUMBERED_LIST = /^([0-9]+)\. (.+)/
    IMAGE = /!\[([^\]]+)\]\(([^)]+)\)/
    QUOTE = /^> (.+)/

    def heading_1(match)
      { type: :heading_1, rich_texts: tokenize_rich_text(match.gsub(/^# /, "")) }
    end

    def heading_2(match)
      { type: :heading_2, rich_texts: tokenize_rich_text(match.gsub(/^## /, "")) }
    end

    def heading_3(match)
      { type: :heading_3, rich_texts: tokenize_rich_text(match.gsub(/^### /, "")) }
    end

    def code_block(match)
      {
        type: :code_block,
        text: match.gsub(/^```[^\n]*\n/, "").gsub(/\n```$/, ""),
        lang: match.gsub(/^```/, "").gsub(/\n.+$/m, "")
      }
    end

    def bullet_list(match, nesting: 0)
      {
        type: :bullet_list,
        rich_texts: tokenize_rich_text(match.gsub(/^- /, "")),
        nesting: nesting
      }
    end

    def numbered_list(match, nesting: 0)
      {
        type: :numbered_list,
        rich_texts: tokenize_rich_text(match.gsub(/^[0-9]+\. /, "")),
        number: match.gsub(/\..+$/, "").to_i,
        nesting: nesting
      }
    end

    def image(match)
      {
        type: :image,
        rich_texts: tokenize_rich_text(match.gsub(/!\[([^\]]+)\]\(([^)]+)\)/, '\1')),
        link: match.gsub(/!\[([^\]]+)\]\(([^)]+)\)/, '\2')
      }
    end

    def paragraph(match)
      { type: :paragraph, rich_texts: tokenize_rich_text(match) }
    end

    def quote(match)
      { type: :quote, rich_texts: tokenize_rich_text(match.gsub(/^> /, "")) }
    end

    ## rich text objects

    def tokenize_rich_text(text)
      # use a regular expression to capture all the rich text elements and the text between them as separate groups
      groups = text.scan(/(`[^`]*`|\*\*[^*]*\*\*|\*[^*]*\*|~~[^~]*~~|[^`*~]+)/).flatten

      # map the groups to tokens
      groups.map do |group|
        case group
        when /^`/
          code(group)
        when /^\*\*/
          bold(group)
        when /^\*/
          italic(group)
        when /^~~/
          strikethrough(group)
        else
          text(group)
        end
      end
    end

    def code(text)
      { type: :code, text: text.gsub(/^`/, "").gsub(/`$/, "") }
    end

    def italic(match)
      { type: :italic, text: match.gsub(/\*/, "") }
    end

    def bold(match)
      { type: :bold, text: match.gsub(/\*/, "") }
    end

    def text(match)
      { type: :text, text: match }
    end

    def strikethrough(match)
      { type: :strikethrough, text: match.gsub(/~~/, "") }
    end
  end
end
