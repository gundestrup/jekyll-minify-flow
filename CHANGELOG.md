<!--
Copyright (C) 2025  gandaro
Copyright (C) 2026  Svend Gundestrup
SPDX-License-Identifier: MIT AND AGPL-3.0-or-later
-->

# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added

- Standalone CSS minification via the `lightningcss` gem: every `.css` file
  written to the destination — static files and `.scss` sources compiled by
  Jekyll — is minified at site `post_write` with priority `:high`, ahead of
  Fingerprint Flow (12) and Compress Flow (10). A new `minify_css` map in
  `_config.yml` exposes `enabled`, `minify`, `error_recovery`, `targets`,
  `css_modules` and `scope`; invalid values fail the build, and parse errors
  name the offending file.
- Dependabot configuration for weekly `bundler` and `github-actions` updates.
- `test/system/` suite: builds the `.gem` artifact, verifies packaged files
  and metadata via `Gem::Package`, extracts the package and runs a real
  `jekyll build` against it via `bundle exec` — catches `spec.files` gaps.
- Rebuild-idempotency test: a second build on the same destination stays
  correctly minified.

### Changed

- Renamed the project/gem to `jekyll-minify-flow` (gemspec, lib entry
  point, `JekyllMinifyFlow` module, packaged files, docs). Configuration
  keys `minify_html`/`minify_css` are unchanged.
- Relicensed: the fork's new work is now AGPL-3.0-or-later (`LICENSE`),
  while the original upstream code remains MIT (`LICENSE.MIT`). The
  gemspec `license` field and packaged file list were updated
  accordingly.
- Test suite migrated from RSpec to Minitest (`test/`), keeping the
  real-Jekyll-site assertions; `rubocop-rspec` replaced with
  `rubocop-minitest`. `test_helper` carries SimpleCov (CI-gated Cobertura,
  per-suite `command_name` so unit and system coverage merge), `-w`
  warnings, and a 98/90 coverage gate on CI.

- `required_ruby_version` is now capped at `< 3.5.dev` — the `minify_html`
  dependency (0.18.1) declares `Ruby < 3.5.dev` and ships no precompiled
  binary for Ruby 4.0, so installing on Ruby 4 failed at dependency
  resolution. The cap makes the constraint explicit; it can be lifted once
  upstream ships Ruby 4.0 support (wilsonzlin/minify-html#278).
- Specs no longer read `Jekyll::Hooks` internals (`@registry`,
  `@hook_priority`): hook registration is now verified via the public
  `Jekyll::Hooks.trigger` API, and `post_write` probe cleanup uses a
  deactivation flag instead of mutating the registry.

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
