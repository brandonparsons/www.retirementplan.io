xml.instruct! :xml, version: '1.0'
xml.tag! 'urlset', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9' do

  # Home page
  xml.url{
    xml.loc(root_url)
    xml.changefreq("weekly")
    xml.priority(1.0)
  }

  # Static pages
  static_pages = %w{
    about
    asset-allocation
    disclosures
    instant-notification
    our-video
    privacy
    retirement-planning
    terms
    tour
  }
  static_pages.each do |page_id|
    xml.url{
      xml.loc("#{ENV['PRODUCTION_URL']}/#{page_id}")
      xml.changefreq("weekly")
      xml.priority(0.9)
    }
  end

  # Blog
  xml.url{
    xml.loc("#{ENV['PRODUCTION_URL']}/blog")
    xml.changefreq("weekly")
    xml.priority(0.9)
  }
  RSS::Parser.parse("#{ENV['BLOG_HOST']}/rss/", false).channel.items.map(&:link).each do |post_url|
    xml.url{
      xml.loc(post_url)
      xml.changefreq("monthly")
      xml.priority(0.8)
    }
  end

  # Asset Classes
  xml.url{
    xml.loc(asset_classes_url)
    xml.changefreq("monthly")
    xml.priority(0.7)
  }
  AssetsService.all.each do |asset_class|
    xml.url{
      xml.loc(asset_class_url(asset_class.id))
      xml.changefreq("monthly")
      xml.priority(0.6)
    }
  end

  # ETFs
  EtfsService.all.each do |etf|
    xml.url{
      xml.loc(etf_url(etf.id))
      xml.changefreq("monthly")
      xml.priority(0.6)
    }
  end

end
