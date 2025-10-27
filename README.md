This Jekyll plugin uses [minify-html](https://crates.io/crates/minify-html) to minify HTML files produced by Jekyll.

## Installation

Add the following line to the Gemfile:

```rb
gem "jekyll-minify-html-rs", :git => "https://github.com/gandaro/jekyll-minify-html-rs.git"
```

Add `jekyll-minify-html-rs` to the `plugins` list in `_config.yml`:

```yaml
plugins:
  - ...
  - jekyll-minify-html-rs
```
