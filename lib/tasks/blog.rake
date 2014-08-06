task :default => [:update_site]

task :update_site => :environment do
  puts "Updating blog post content..."
  Post.run_update
  puts "Done."
end
