# frozen_string_literal: true

require_relative "lib/md_to_notion/version"

Gem::Specification.new do |spec|
  spec.name = "md_to_notion"
  spec.version = MdToNotion::VERSION
  spec.authors = ["rieg-ec"]
  spec.email = ["rieg.10199@gmail.com"]

  spec.summary = "Markdown to Notion converter."
  spec.description = "Convert Markdown and GitHub Flavoured Markdown to Notion API Blocks and RichText."
  spec.homepage = "https://github.com/rieg-ec/md-to-notion"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/rieg-ec/md-to-notion"
  spec.metadata["changelog_uri"] = "https://github.com/rieg-ec/md-to-notion/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
