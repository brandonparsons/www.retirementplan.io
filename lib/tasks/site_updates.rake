task regular_update: [:get_simulation_count]

desc "Loads simulation count from app server"
task get_simulation_count: :environment do
  require 'json'
  puts "Grabbing simulation count..."
  response = Faraday.new(url: ENV['API'] + '/simulation_count').get
  json                  = JSON.parse response.body
  number_of_simulations = json['simulations']
  $redis.set $SIMULATION_COUNT_KEY, number_of_simulations
  puts "Set simulation count to #{number_of_simulations}."
end

desc "Updates posts from git repository"
task update_posts: :environment do
  Post.run_update
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
  puts "Done."
end

desc "Resets cache, and re-fills by hitting pages"
task reset_cache: :environment do
  Rails.cache.clear
  Post.fill_cache
end
