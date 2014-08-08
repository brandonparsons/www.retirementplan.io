xml.instruct! :xml, version: '1.0'
xml.tag! 'urlset', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9' do

  # Home page
  xml.url{
    xml.loc(root_url)
    xml.changefreq("weekly")
    xml.priority(1.0)
  }

  # Static pages
  pages_dir = Rails.root.join("app", "views", "pages")
  pages = Dir.glob("#{pages_dir}/*")
  pages.each do |path|
    slug = File.basename(path) # e.g. about.html.md
    page_id = slug.match(/^(.*)\.html.*$/)[1]  # pulls out `about`. A bit of a kluge... may not work for everything but not overly important

    xml.url{
      xml.loc("#{ENV['PRODUCTION_URL']}/#{page_id}")
      xml.changefreq("weekly")
      xml.priority(0.9)
    }
  end

  # Blog index
  xml.url{
    xml.loc(posts_url)
    xml.changefreq("daily")
    xml.priority(0.7)
  }

  # Blog posts
  Post.all.each do |p|
    xml.url {
      xml.loc(p.path)
      xml.changefreq("weekly")
      xml.priority(0.5)
    }
  end
end
