task :default => [:update_posts]

task :update_posts do
  puts "Updating post content....."
  # `git clone #{BLOG_GIT_CONTENT_URL}`
end
