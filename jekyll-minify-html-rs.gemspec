# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = "jekyll-minify-html-rs"
  s.version     = "1.1.0"
  s.summary     = "HTML minifier for Jekyll"
  s.description = "A Jekyll plugin that uses the minify-html Rust crate to minify HTML files."
  s.authors     = ["gandaro"]
  s.homepage    = "https://github.com/gundestrup/jekyll-minify-html-rs"
  s.license     = "MIT"
  s.metadata    = {
    "source_code_uri" => "https://github.com/gundestrup/jekyll-minify-html-rs",
    "changelog_uri" => "https://github.com/gundestrup/jekyll-minify-html-rs/blob/main/CHANGELOG.md",
    "rubygems_mfa_required" => "true"
  }

  s.required_ruby_version = ">= 3.3.0"
  s.files = Dir["lib/**/*", "README.md", "LICENSE", "CHANGELOG.md"]

  s.add_dependency "jekyll", ">= 4.4", "< 5.0"
  s.add_dependency "minify_html", "~> 0.18.1"
end
