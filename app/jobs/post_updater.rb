class PostUpdater
  include SuckerPunch::Job

  def perform()
    Post.run_update
    Post.fill_cache
  end
end
