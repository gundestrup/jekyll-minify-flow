# Changelog

All notable changes to this project will be documented in this file.

## [1.1.0] - 2026-10-06

### Added

- `_config.yml` configuration: a `minify_html` map is now read from the site
  config and merged over the defaults, so every `minify-html` `Cfg` option is
  adjustable — previously the options were hardcoded with no way to change
  them. Unknown option names, non-boolean values and non-map config fail
  the build with a descriptive error.
- README configuration section documenting all 15 supported options with
  their defaults.
- RSpec suite covering HTML, CSS and JS minification, options loaded from
  `_config.yml`, CSS/JS opt-outs, invalid configuration, static and non-HTML
  passthrough, and hook ordering before site `post_write` — specs build real
  Jekyll sites in tmpdirs.
- Development scaffolding: `Gemfile`, `Rakefile` (`quick`/`ci`/`quality`),
  `.rubocop.yml`, `.ruby-version` (3.4.10), and a GitHub Actions `ci.yml`
  (Ruby 3.3/3.4 matrix, bundler-audit, Codecov on 3.4).

### Changed

- Dropped the redundant `keep_ssi_comments: false` from the option hash —
  the `minify_html` gem already defaults unset options to `false`, and the
  option can now be enabled via site config if needed.
- gemspec now declares the `jekyll` runtime dependency (`>= 4.4, < 5.0`)
  and `required_ruby_version >= 3.3.0` — the plugin calls `Jekyll::Hooks`
  at load time, so Jekyll was always required but never declared. The gem
  now also ships `README.md`/`LICENSE`/`CHANGELOG.md`.
- Gem homepage and source/changelog metadata point to this fork. README
  documents installing the fork until version 1.1.0 is published, and
  clarifies that static HTML files are copied unchanged.

## [1.0.0] - 2025-10-28

### Added

- Initial release: `:post_render` hook on `[:pages, :documents]` minifying
  `.html` output with `minify-html` (hardcoded `minify_css`/`minify_js`
  enabled).
