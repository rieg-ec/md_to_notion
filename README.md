# MdToNotion: Markdown to Notion

Dependency-free gem to convert markdown and GitHub flavoured Markdown to Notion API blocks and richtext.

NOTE: this is a work in progress. It works for simple markdown, but has not been tested with all markdown syntax.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add md_to_notion

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install md_to_notion

## Usage

```ruby
MdToNotion::Parser.markdown_to_notion_blocks(
  "# heading 1"
)
```

<details>
<summary>result</summary>

```json
{
    "type": "heading_1",
    "heading_1": {
      "rich_text": [
        {
          "type": "text",
          "text": {
            "content": "heading 1",
            "link": null
          },
          "annotations": {
            "bold": false,
            "italic": false,
            "strikethrough": false,
            "underline": false,
            "code": false
          },
          "href": null
        }
      ]
    }
  }
```
</details>

<br>

```ruby
MdToNotion::Parser.markdown_to_notion_blocks(
  "> quote with *italic"
)
```
<details>
<summary>result</summary>

```json
{
  "type": "quote",
  "quote": {
    "rich_text": [
      {
        "type": "text",
        "text": {
          "content": "quote with ",
          "link": null
        },
        "annotations": {
          "bold": false,
          "italic": false,
          "strikethrough": false,
          "underline": false,
          "code": false
        },
        "href": null
      },
      {
        "type": "text",
        "text": {
          "content": "italic",
          "link": null
        },
        "annotations": {
          "bold": false,
          "italic": true,
          "strikethrough": false,
          "underline": false,
          "code": false
        },
        "href": null
      }
    ]
  }
}
```
</details>

<br>

```ruby
MdToNotion::Parser.markdown_to_notion_blocks <<~CODE
``ruby
puts 'it works with code blocks too!'
``
CODE
```
<details>
<summary>result</summary>

```json
{
  "type": "code",
  "code": {
    "rich_text": [
      {
        "type": "text",
        "text": {
          "content": "puts 'it works with code blocks too!'",
          "content": null
        },
        "annotations": {
          "bold": false,
          "italic": false,
          "strikethrough": false,
          "underline": false,
          "code": false
        },
        "href": null
      }
    ],
    "language": "ruby"
  }
}
```
</details>

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rieg-ec/md_to_notion.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
