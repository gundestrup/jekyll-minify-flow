require "minify_html"

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  if doc.output_ext != ".html"
    next
  end

  doc.output = minify_html(
    doc.output,
    {
      :keep_ssi_comments => false,
      :minify_css => true,
      :minify_js => true
    }
  )
end
