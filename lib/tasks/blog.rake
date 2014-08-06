task :default => [:update_posts]

task :update_posts do
  puts "Updating post content....."

  bin_dir           = Rails.root.join("bin").to_s
  git_clone_command = "#{bin_dir}/git-as.sh #{ENV['BLOG_DEPLOY_KEY_LOCATION']} clone git@#{ENV['BLOG_GIT_REPO_URL']}"
  target_dir        = Rails.root.join("blog_content").to_s

  `#{git_clone_command} #{target_dir}`

  puts "Finished grabbing content..."
end
