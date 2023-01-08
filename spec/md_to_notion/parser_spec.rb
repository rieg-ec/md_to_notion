# frozen_string_literal: true

require "json"

require "spec_helper"
require "md_to_notion/parser"

RSpec.describe MdToNotion::Parser do
  describe ".markdown_to_notion_blocks" do
    it "translates markdown to notion blocks" do
      [1, 2].each do |i|
        markdown = File.read("spec/fixtures/test#{i}.md")
        notion_blocks = File.read("spec/fixtures/test#{i}_blocks.json")
        blocks = MdToNotion::Parser.markdown_to_notion_blocks(markdown)
        expect(blocks).to eq(JSON.parse(notion_blocks, symbolize_names: true))
      end
    end
  end
end
