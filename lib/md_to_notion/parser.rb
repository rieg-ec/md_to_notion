require_relative "./lexer"
require_relative "./blocks"

module MdToNotion
  module Parser
    def self.markdown_to_ast(markdown)
      lexer = Lexer.new(markdown)
      lexer.tokenize
    end

    def self.markdown_to_notion_blocks(markdown)
      ast = markdown_to_ast(markdown)
      ast_to_notion_blocks(ast)
    end

    def self.ast_to_notion_blocks(ast)
      ast.map do |token|
        case token[:type]
        when :heading_1
          Block.heading_1(token[:rich_texts])
        when :heading_2
          Block.heading_2(token[:rich_texts])
        when :heading_3
          Block.heading_3(token[:rich_texts])
        when :paragraph
          Block.paragraph(token[:rich_texts])
        when :code_block
          Block.code(token[:text], lang: token[:lang])
        when :bullet_list
          Block.bulleted_list_item(token[:rich_texts])
        when :numbered_list
          Block.numbered_list(token[:rich_texts])
        when :image
          Block.image(token[:text], token[:rich_texts])
        when :quote
          Block.quote(token[:rich_texts])
        end
      end
    end
  end
end
