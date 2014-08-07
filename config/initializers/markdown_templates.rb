require 'rouge/plugins/redcarpet'

class MarkdownRenderer
  class HTMLWithRouge < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet
  end

  def initialize
    @markdown = ::Redcarpet::Markdown.new(HTMLWithRouge,
      fenced_code_blocks: true, smartypants: true, no_intra_emphasis: true,
      autolink: true, tables: true, hard_wrap: true, strikethrough: true
    )
  end

  def render(text)
    @markdown.render(text)
  end
end


class ActionView::Template

  class MarkdownTemplateHandler
    def self.erb
      @erb ||= ActionView::Template.registered_template_handler(:erb)
    end

    def self.call(template)
      source = erb.call(template)
      <<-SOURCE
      ::MarkdownRenderer.new.render(begin;#{source};end)
      SOURCE
    end
  end

  register_template_handler(:md, :markdown, MarkdownTemplateHandler)
end
