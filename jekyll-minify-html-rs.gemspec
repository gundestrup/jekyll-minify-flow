Gem::Specification.new do |s|
  s.name        = "jekyll-minify-html-rs"
  s.version     = "1.0.0"
  s.summary     = "HTML minifier for Jekyll"
  s.description = "A Jekyll plugin that uses the minify-html Rust crate to minify HTML files."
  s.authors     = ["gandaro"]
  s.files       = ["lib/jekyll-minify-html-rs.rb"]

  s.add_dependency 'minify_html', '~> 0.18.1'
end
