# frozen_string_literal: true

require "jekyll"
require "minify_html"

module JekyllMinifyHtmlRs
  DEFAULT_OPTIONS = { minify_css: true, minify_js: true }.freeze
  OPTION_NAMES = %w[
    allow_noncompliant_unquoted_attribute_values allow_optimal_entities
    allow_removing_spaces_between_attributes keep_closing_tags keep_comments
    keep_html_and_head_opening_tags keep_input_type_text_attr keep_ssi_comments
    minify_css minify_doctype minify_js preserve_brace_template_syntax
    preserve_chevron_percent_template_syntax remove_bangs remove_processing_instructions
  ].freeze

  def self.options_for(site)
    configured = site.config.fetch("minify_html", {})
    raise Jekyll::Errors::FatalException, "minify_html must be a map of options" unless configured.is_a?(Hash)

    configured.each_with_object(DEFAULT_OPTIONS.dup) do |(key, value), options|
      name = key.to_s
      raise Jekyll::Errors::FatalException, "unknown minify_html option: #{name}" unless OPTION_NAMES.include?(name)
      unless [true, false].include?(value)
        raise Jekyll::Errors::FatalException, "minify_html.#{name} must be true or false"
      end

      options[name.to_sym] = value
    end
  end
end

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  next unless doc.output_ext == ".html"

  doc.output = minify_html(doc.output, JekyllMinifyHtmlRs.options_for(doc.site))
end
