# frozen_string_literal: true

# Copyright (C) 2026  Svend Gundestrup
# SPDX-License-Identifier: AGPL-3.0-or-later

require "simplecov"
require "simplecov-cobertura" if ENV["CI"]

SimpleCov.start do
  enable_coverage :branch
  command_name ENV.fetch("COVERAGE_RUN", "Unit Tests")
  skip "/test/"
  minimum_coverage line: 98, branch: 90 if ENV["CI"] || ENV["COVERAGE"]
  if ENV["CI"]
    formatter SimpleCov::Formatter::MultiFormatter.new([
                                                         SimpleCov::Formatter::CoberturaFormatter,
                                                         SimpleCov::Formatter::JSONFormatter
                                                       ])
  end
end

require "jekyll"
require "jekyll-minify-flow"
require "minitest/autorun"
require "fileutils"
require "tmpdir"

PROJECT_ROOT = File.expand_path("..", __dir__)

Dir.glob(File.expand_path("support/**/*.rb", __dir__), sort: true).each { |f| require f }

class JekyllMinifyFlowTest < Minitest::Test
  PAGE_HTML = <<~HTML
    ---
    ---
    <!DOCTYPE html>
    <html>
    <head>
    <style>
      body {
        color: red;
      }
    </style>
    </head>
    <body>
    <!-- keep me -->
    <script>
      function foo() {
        return 1;
      }
    </script>
    <p>   Hello   </p>
    </body>
    </html>
  HTML

  def setup
    @source = Dir.mktmpdir
    @dest = Dir.mktmpdir
    write_source("index.html", PAGE_HTML)
  end

  def teardown
    FileUtils.remove_entry(@source)
    FileUtils.remove_entry(@dest)
  end

  private

  def write_source(name, content)
    File.write(File.join(@source, name), content)
  end

  def read_dest(name)
    File.read(File.join(@dest, name))
  end

  def build_site(config = {})
    site_config = { "source" => @source, "destination" => @dest, "quiet" => true }.merge(config)
    Jekyll::Site.new(Jekyll.configuration(site_config)).process
    read_dest("index.html")
  end
end
