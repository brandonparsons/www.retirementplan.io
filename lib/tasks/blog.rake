task :default => [:update_site]

task :update_site => :environment do
  puts "Updating blog post content..."
  Post.run_update
  puts "Done."
end

desc "Pings google/bing with sitemap update"
task :ping_google  do
  puts "Pinging search engines..."
  sitemap_url = "#{ENV['PRODUCTION_URL']}/sitemap.xml"
  services = [
    "http://www.google.com/webmasters/sitemaps/ping?sitemap=",
    "http://www.bing.com/webmaster/ping.aspx?siteMap="
  ]

  services.each do |ping_url|
    Faraday.new(url: "#{ping_url}#{sitemap_url}").get
  end
end
