require 'fileutils'
require 'digest'

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

    def all_tags
      all.map(&:tags).flatten.uniq.sort
    end

    def with_tag(tag)
      all.select{|post| post.tags.include?(tag)}
    end

    def feed
      all.take(10)
    end

    def last_post_date
      all.first.date
    end

    def run_update
      tmp_post_content_location = Rails.root.join "tmp", "blog_content"

      if Dir.exists? tmp_post_content_location
        `cd #{tmp_post_content_location} && #{git_pull}`
      else
        `#{git_clone} #{tmp_post_content_location}`
      end

      # Handle posts
      FileUtils.mkdir_p(blog_content_directory)
      copy_directory("#{tmp_post_content_location}/posts", blog_content_directory)

      # Handle images
      FileUtils.mkdir_p("#{public_dir}/images")
      copy_directory("#{tmp_post_content_location}/images", "#{public_dir}/images/blog")
    end

    def fill_cache
      # Blog index page
      Faraday.new(url: "#{ENV['PRODUCTION_URL']}/blog").get

      # Individual posts
      all.each do |post|
        Faraday.new(url: ENV['PRODUCTION_URL'] + post.path).get
      end
    end

    def cache_key_for_posts(posts)
      Digest::MD5.hexdigest posts.map{|post| post.cache_key}.join("--")
    end

    def blog_content_directory
      Rails.root.join 'blog_content'
    end


    private

    def all_slugs
      Dir.glob("#{blog_content_directory}/*.md").map { |f| File.basename(f,'.md') }
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
    @data = SafeYAML.load(file_data)
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

  def author
    @data['author'] || "RetirementPlan.io Contributor"
  end

  def formatted_date
    day_format = ActiveSupport::Inflector.ordinalize(date.day)
    date.strftime "%B #{day_format}, %G"
  end

  def html
    Jekyll::Converters::Markdown::RedcarpetParser.new({
      'highlighter' => 'rouge',
      'redcarpet' => {
        'extensions' => ["no_intra_emphasis", "fenced_code_blocks", "autolink", "strikethrough", "lax_spacing", "superscript", "with_toc_data"]
      }
    }).convert(markdown)
  end

  def excerpt
    first_ptag = Nokogiri::HTML(html).css('p:first').text.squish
    post_excerpt = truncate(strip_tags(first_ptag), length: 200, separator: ' ')
    if (post_excerpt.length == 0) && @data['summary'].present?
      post_excerpt = @data['summary']
    end
    post_excerpt
  end

  def related_posts
    @related_posts ||= begin
      # This is an expensive method. Call with care.
      post_references     = {}
      my_markdown_content = markdown
      lsi                 = Classifier::LSI.new

      self.class.all.each do |post|
        post_markdown_content = post.send :markdown
        content_hash          = Digest::MD5.hexdigest(post_markdown_content)
        post_references[content_hash] = post.slug
        lsi.add_item(post_markdown_content, *post.tags)
      end

      related = lsi.find_related(my_markdown_content, 3)

      if related.any?
        related = related.map do |related_post_content|
          hash = Digest::MD5.hexdigest(related_post_content)
          post_references[hash]
        end
      end

      related
    end
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
    ActiveSupport::Cache.expand_cache_key ['post', slug, md5(markdown), md5(@data.sort.to_json)]
  end


  private

  def md5(str)
    Digest::MD5.hexdigest(str)
  end

  def file_path
    self.class.blog_content_directory.join "#{slug}.md"
  end

  def file_data
    File.read(file_path)
  end

  def markdown
    Tilt::ErubisTemplate.new do
      fdata = file_data
      if fdata =~ /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
        _ = SafeYAML.load($1) # Discard YAML frontmatter
        $POSTMATCH
      else
        fdata
      end
    end.render(scope, post: self)
  end

  def scope
    ApplicationController.helpers.clone.tap do |h|
      h.singleton_class.send :include, Rails.application.routes.url_helpers
    end
  end

end
