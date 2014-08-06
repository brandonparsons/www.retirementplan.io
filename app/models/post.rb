require 'fileutils'

class Post

  include ActionView::Helpers::TextHelper

  attr_reader :slug


  #################
  # CLASS METHODS #
  #################

  class << self

    def all
      all_slugs.map{ |slug| new(slug) }.sort
    end

    def find(slug)
      all.detect{ |post| post.slug == slug }
    end

    def run_update
      tmp_post_content_location = Rails.root.join "tmp", "blog_content"

      if Dir.exists? tmp_post_content_location
        `cd #{tmp_post_content_location} && #{git_pull}`
      else
        `#{git_clone} #{tmp_post_content_location}`
      end

      copy_directory("#{tmp_post_content_location}/posts", blog_content_directory)
      copy_directory("#{tmp_post_content_location}/images", "#{public_dir}/images")
    end

    private

    def all_slugs
      Dir.glob("#{blog_content_directory}/*.md").map { |f| File.basename(f,'.md') }
    end

    def blog_content_directory
      Rails.root.join 'blog_content'
    end

    def bin_dir
      Rails.root.join "bin"
    end

    def ssh_key_location
      Rails.root.join ENV['BLOG_DEPLOY_KEY_LOCATION']
    end

    def git_pull
      "#{bin_dir}/git-as.sh #{ssh_key_location} pull"
    end

    def git_clone
      "#{bin_dir}/git-as.sh #{ssh_key_location} clone git@#{ENV['BLOG_GIT_REPO_URL']}"
    end

    def public_dir
      Rails.root.join "public"
    end

    def copy_directory(from, to)
      `cp -a #{from}/. #{to}/`
    end

  end


  ####################
  # INSTANCE METHODS #
  ####################

  def initialize(slug)
    @slug = slug
    @data = {}
    parse_file
  end

  def title
    @data['title'] || slug.sub(/\d{4}-\d{2}-\d{2}-/, '').titleize
  end

  def date
    Date.parse(slug).to_time
  end

  def tags
    @data['tags'] || []
  end

  def formatted_date
    day_format = ActiveSupport::Inflector.ordinalize(date.day)
    date.strftime "%B #{day_format}, %G"
  end

  def html
    # Rails.cache.fetch("#{cache_key}/html") { to_html }
    to_html
  end

  def excerpt
    first_ptag = Nokogiri::HTML(html).css('p:first').text.squish
    truncate strip_tags(first_ptag), length: 200, separator: ' '
  end

  def path
    "/blog/#{slug}"
  end

  def inspect
    "<#{self.class.name} date: #{date.iso8601}, title: #{title.inspect}, slug: #{slug.inspect}>"
  end

  def <=> other
    other.date <=> date
  end

  def updated_at
    if updated_yaml_frontmatter = @data['updated']
      return Date.parse(updated_yaml_frontmatter).to_time.utc
    else
      return date.utc
    end
  end

  def cache_key
    ActiveSupport::Cache.expand_cache_key ['blog', slug, updated_at.to_i]
  end


  private

  def parse_file
    @markdown = Tilt::ErubisTemplate.new do
      fdata = file_data
      if fdata =~ /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
        @data = SafeYAML.load($1)
        $POSTMATCH
      else
        fdata
      end
    end.render(scope, post: self)
  end

  def file_path
    self.class.send(:blog_content_directory).join "#{slug}.md"
  end

  def file_data
    # Rails.cache.fetch("#{cache_key}/markdown") { File.read(file_path) }
    File.read(file_path)
  end

  def markdown
    @markdown
  end

  def to_html
    Jekyll::Converters::Markdown::RedcarpetParser.new({
      'highlighter' => 'rouge',
      'redcarpet' => {
        'extensions' => ["no_intra_emphasis", "fenced_code_blocks", "autolink", "strikethrough", "lax_spacing", "superscript", "with_toc_data"]
      }
    }).convert(markdown)
  end

  def scope
    ApplicationController.helpers.clone.tap do |h|
      h.singleton_class.send :include, Rails.application.routes.url_helpers
    end
  end

end
