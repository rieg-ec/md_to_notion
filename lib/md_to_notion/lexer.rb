# frozen_string_literal: true

require_relative "./tokens"

module MdToNotion
  class Lexer
    include Tokens

    class InvalidTokenSyntaxError < StandardError; end

    def initialize(markdown)
      @markdown = markdown
      @tokens = []
      @stack = []
      @index = 0
    end

    def tokenize
      while @index < @markdown.length
        begin
          next_char = @markdown[@index]

          if next_char == " "
            @index += 1
            next @stack << " "
          elsif next_char == "#"
            tokenize_heading
          elsif next_char == "["
            tokenize_link
          elsif next_char == "!"
            tokenize_image
          elsif next_char == ">"
            tokenize_quote
          elsif next_char == "-"
            tokenize_bullet_list
          elsif next_char =~ /\d+/
            tokenize_numbered_list
          elsif next_char == "`" && peek(2) == "```"
            tokenize_block_code
          elsif next_char == "\n"
            @index += 1
          else
            tokenize_paragraph
          end
        rescue InvalidTokenSyntaxError
          tokenize_paragraph
        end

        @stack = []
      end

      @tokens
    end

    private

    def peek(n = 1)
      @markdown[@index..@index + n]
    end

    def tokenize_heading
      line = @markdown[@index..].split("\n").first
      if line =~ HEADING_1
        @tokens << heading_1(::Regexp.last_match(0))
      elsif line =~ HEADING_2
        @tokens << heading_2(::Regexp.last_match(0))
      elsif line =~ HEADING_3
        @tokens << heading_3(::Regexp.last_match(0))
      else
        return raise InvalidTokenSyntaxError, "Invalid heading: #{line}"
      end

      @index += ::Regexp.last_match(0).length
    end

    def tokenize_block_code
      raise InvalidTokenSyntaxError, "Invalid code block: #{@markdown[@index..]}" \
        unless @markdown[@index..] =~ CODE_BLOCK

      @tokens << code_block(::Regexp.last_match(0))
      @index += ::Regexp.last_match(0).length
    end

    def tokenize_bullet_list
      line = @markdown[@index..].split("\n").first
      raise InvalidTokenSyntaxError, "Invalid bullet list: #{line}" \
        unless line =~ BULLET_LIST

      nesting = @stack.count(" ")
      @stack = []

      @tokens << bullet_list(::Regexp.last_match(0), nesting: nesting)
      @index += ::Regexp.last_match(0).length
    end

    def tokenize_link
      line = @markdown[@index..].split("\n").first
      raise InvalidTokenSyntaxError, "Invalid link syntax: #{line}" \
        unless line =~ LINK

      @tokens << link(::Regexp.last_match(0))
      @index += ::Regexp.last_match(0).length
    end

    def tokenize_image
      line = @markdown[@index..].split("\n").first
      raise InvalidTokenSyntaxError, "Invalid image syntax: #{line}" \
        unless line =~ IMAGE

      @tokens << image(::Regexp.last_match(0))
      @index += ::Regexp.last_match(0).length
    end

    def tokenize_quote
      line = @markdown[@index..].split("\n").first
      raise InvalidTokenSyntaxError, "Invalid quote syntax: #{line}" \
        unless line =~ QUOTE

      @tokens << quote(::Regexp.last_match(0))
      @index += ::Regexp.last_match(0).length
    end

    def tokenize_numbered_list
      line = @markdown[@index..].split("\n").first
      raise InvalidTokenSyntaxError, "Invalid numbered list: #{line}" \
        unless line =~ NUMBERED_LIST

      nesting = @stack.count(" ")
      @stack = []

      @tokens << numbered_list(::Regexp.last_match(0), nesting: nesting)
      @index += ::Regexp.last_match(0).length
    end

    def tokenize_paragraph
      line = @markdown[@index..].split("\n").first
      @tokens << paragraph(line)
      @index += line.length
    end

    def tokenize_strikethrough
      line = @markdown[@index..].split("\n").first
      raise InvalidTokenSyntaxError, "Invalid strikethrough syntax: #{line}" \
        unless line =~ STRIKETHROUGH

      @tokens << strikethrough(::Regexp.last_match(0))
      @index += ::Regexp.last_match(0).length
    end
  end
end
