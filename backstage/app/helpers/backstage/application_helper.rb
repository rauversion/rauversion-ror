module Backstage
  module ApplicationHelper

    def markdown(text)
      return '' if text.blank?
  
      renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)
      options = {
        autolink: true,
        no_intra_emphasis: true,
        fenced_code_blocks: true,
        lax_html_blocks: true,
        strikethrough: true,
        superscript: true,
        space_after_headers: true
      }
      Redcarpet::Markdown.new(renderer, options).render(text).html_safe
    end
  end
end
