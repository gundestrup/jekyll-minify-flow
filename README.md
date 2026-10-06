This Jekyll plugin uses [minify-html](https://crates.io/crates/minify-html) to minify rendered HTML pages and documents. Static HTML files without front matter are copied unchanged by Jekyll.

## Installation

Version 1.1.0 is not yet published on RubyGems. After these changes are pushed to the fork, install from its Git repository:

```rb
gem "jekyll-minify-html-rs", git: "https://github.com/gundestrup/jekyll-minify-html-rs", branch: "main"
```

Once version 1.1.0 is published, you can instead use `gem "jekyll-minify-html-rs", "~> 1.1.0"`.

Add `jekyll-minify-html-rs` to the `plugins` list in `_config.yml`:

```yaml
plugins:
  - jekyll-minify-html-rs
```

## Configuration

By default the plugin minifies HTML with inline CSS and JavaScript
minification enabled. Options can be adjusted by adding a `minify_html`
map to `_config.yml`; any option set there overrides the defaults. Option names must match the table below and values must be YAML booleans (`true` or `false`); invalid configuration stops the build:

```yaml
minify_html:
  minify_css: true
  minify_js: true
  keep_comments: false
```

All [Cfg](https://docs.rs/minify-html/0.18.1/minify_html/struct.Cfg.html)
options of the pinned `minify-html` 0.18.1 release are supported:

| Option | Default | Description |
|--------|---------|-------------|
| `minify_css` | `true` | Minify CSS in `<style>` tags and `style` attributes |
| `minify_js` | `true` | Minify JavaScript in `<script>` tags |
| `keep_closing_tags` | `false` | Do not omit closing tags when possible |
| `keep_comments` | `false` | Keep all comments |
| `keep_html_and_head_opening_tags` | `false` | Do not omit `<html>` and `<head>` opening tags |
| `keep_input_type_text_attr` | `false` | Keep `type=text` attribute name and value on `<input>` elements |
| `keep_ssi_comments` | `false` | Keep SSI comments |
| `minify_doctype` | `false` | Minify DOCTYPEs (may not be spec compliant) |
| `preserve_brace_template_syntax` | `false` | Pass `{{ }}`, `{# #}`, `{% %}` template code through untouched |
| `preserve_chevron_percent_template_syntax` | `false` | Pass `<% %>` template code through untouched |
| `remove_bangs` | `false` | Remove all bangs |
| `remove_processing_instructions` | `false` | Remove all processing instructions |
| `allow_noncompliant_unquoted_attribute_values` | `false` | Allow unquoted attribute values prohibited by the WHATWG spec |
| `allow_optimal_entities` | `false` | Allow entity minifications that may not pass validation |
| `allow_removing_spaces_between_attributes` | `false` | Allow removing spaces between attributes when possible |

The plugin runs at page/document `post_render`, before site `post_write` hooks such as Fingerprint Flow (priority 12) and Compress Flow (priority 10). Fingerprinting therefore sees rendered, minified HTML; compression runs after URL rewriting. Jekyll 4.4+ and Ruby 3.3+ are the supported versions.

## Development

```bash
bundle install
bundle exec rake quick   # RuboCop + specs
bundle exec rake         # + bundler-audit
```

The specs build real Jekyll sites in tmpdirs and assert on the minified
output.
