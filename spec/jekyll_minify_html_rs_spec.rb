# frozen_string_literal: true

require "spec_helper"

RSpec.describe JekyllMinifyHtmlRs do
  let(:source) { Dir.mktmpdir }
  let(:dest) { Dir.mktmpdir }
  let(:page_html) do
    <<~HTML
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
  end

  before { File.write(File.join(source, "index.html"), page_html) }

  after do
    FileUtils.remove_entry(source)
    FileUtils.remove_entry(dest)
  end

  def build_site(config = {})
    site_config = { "source" => source, "destination" => dest, "quiet" => true }.merge(config)
    Jekyll::Site.new(Jekyll.configuration(site_config)).process
    File.read(File.join(dest, "index.html"))
  end

  it "registers post_render hooks for pages and documents" do
    registry = Jekyll::Hooks.instance_variable_get(:@registry)
    %i[pages documents].each do |container|
      hooks = registry.fetch(container).fetch(:post_render)
      sources = hooks.filter_map { |hook| hook.source_location&.first }
      expect(sources.any? { |file| file.end_with?("jekyll-minify-html-rs.rb") }).to be(true)
    end
  end

  it "defaults to css and javascript minification" do
    expect(described_class::DEFAULT_OPTIONS).to eq(minify_css: true, minify_js: true)
  end

  it "minifies html, css and javascript with default options" do
    output = build_site
    aggregate_failures do
      expect(output).to include("body{color:red}")
      expect(output).to include("function foo(){return 1}")
      expect(output).not_to include("<!-- keep me -->")
      expect(output).not_to include("   Hello")
    end
  end

  it "keeps comments when keep_comments is enabled" do
    output = build_site("minify_html" => { "keep_comments" => true })
    expect(output).to include("<!-- keep me -->")
  end

  it "leaves javascript untouched when minify_js is disabled" do
    output = build_site("minify_html" => { "minify_js" => false })
    aggregate_failures do
      expect(output).to include("return 1;")
      expect(output).to include("body{color:red}")
    end
  end

  it "leaves css untouched when minify_css is disabled" do
    output = build_site("minify_html" => { "minify_css" => false })
    aggregate_failures do
      expect(output).to include("color: red;")
      expect(output).to include("function foo(){return 1}")
    end
  end

  it "reads options from _config.yml and supports other Cfg options" do
    File.write(File.join(source, "_config.yml"), "minify_html:\n  keep_closing_tags: true\n  minify_js: false\n")
    output = build_site
    aggregate_failures do
      expect(output).to include("<p>Hello</p>")
      expect(output).to include("return 1;")
    end
  end

  it "rejects a non-hash minify_html config" do
    expect { build_site("minify_html" => true) }
      .to raise_error(Jekyll::Errors::FatalException, /minify_html must be a map/)
  end

  it "rejects unknown options" do
    expect { build_site("minify_html" => { "minfy_js" => false }) }
      .to raise_error(Jekyll::Errors::FatalException, /minfy_js/)
  end

  it "rejects non-boolean values" do
    expect { build_site("minify_html" => { "keep_comments" => "false" }) }
      .to raise_error(Jekyll::Errors::FatalException, /keep_comments must be true or false/)
  end

  it "leaves static html files unchanged" do
    static_html = "<p>   Static   </p><!-- keep me -->"
    File.write(File.join(source, "static.html"), static_html)
    build_site
    expect(File.read(File.join(dest, "static.html"))).to eq(static_html)
  end

  it "minifies before site post_write hooks" do
    snapshots = []
    hooks = Jekyll::Hooks.instance_variable_get(:@registry).fetch(:site).fetch(:post_write)
    priorities = Jekyll::Hooks.instance_variable_get(:@hook_priority)
    probes = [12, 10].map do |priority|
      probe = proc { |site| snapshots << [priority, File.read(File.join(site.dest, "index.html"))] }
      Jekyll::Hooks.register(:site, :post_write, priority: priority, &probe)
      probe
    end

    build_site
    expect(snapshots.map(&:first)).to eq([12, 10])
    snapshots.each do |snapshot|
      html = snapshot.last
      expect(html).to include("body{color:red}", "function foo(){return 1}")
      expect(html).not_to include("<!-- keep me -->")
    end
  ensure
    probes&.each do |probe|
      hooks.delete(probe)
      priorities.delete(probe)
    end
  end

  it "skips non-html output" do
    File.write(File.join(source, "feed.xml"), <<~XML)
      ---
      ---
      <feed>
        <!-- comment -->
        <x>   spaced   </x>
      </feed>
    XML
    build_site
    xml = File.read(File.join(dest, "feed.xml"))
    aggregate_failures do
      expect(xml).to include("<!-- comment -->")
      expect(xml).to include("   spaced   ")
    end
  end

  it "minifies documents, not just pages" do
    FileUtils.mkdir_p(File.join(source, "_posts"))
    File.write(File.join(source, "_posts", "2026-01-01-test.md"), <<~MD)
      ---
      ---
      <p>   spaced   </p>
    MD
    build_site
    post = File.read(File.join(dest, "2026", "01", "01", "test.html"))
    expect(post).to include("<p>spaced")
  end
end
