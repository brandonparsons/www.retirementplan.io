# Heroku restarts dynos. Make sure blog content is available on load.
Post.run_update unless Dir.exists? Post.blog_content_directory
