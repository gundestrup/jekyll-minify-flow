# frozen_string_literal: true

require "bundler/gem_tasks"

GEMSPEC_FILE = File.expand_path("jekyll-minify-html-rs.gemspec", __dir__)

task default: :quality

desc "Run all quality checks (style, security, tests)"
task quality: %i[rubocop bundler_audit spec]

desc "Run quick checks (style + tests only)"
task quick: %i[rubocop spec]

desc "Run the test suite and syntax checks (CI)"
task :ci do
  sh "bundle exec rspec"
  sh "bundle exec rubocop"
  Dir["lib/**/*.rb"].each { |file| sh "bundle exec ruby -c #{file}" }
  sh "gem build #{GEMSPEC_FILE}"
end

desc "Check code style with RuboCop"
task :rubocop do
  sh "bundle exec rubocop"
end

desc "Auto-fix RuboCop issues"
task :rubocop_fix do
  sh "bundle exec rubocop -a"
end

desc "Run security audit"
task :bundler_audit do
  sh "bundle exec bundler-audit check --update"
end

desc "Run Ruby tests"
task :spec do
  sh "bundle exec rspec"
end

desc "Build the gem"
task :build_gem do
  sh "gem build #{GEMSPEC_FILE}"
end
