class BlogController < ApplicationController

  def index
    @posts = Post.all
    fresh_when etag: @posts, public: true
  end

  def show
    @post = Post.find params[:id]
    redirect_to blog_index_path unless @post
    fresh_when etag: @post, last_modified: @post.updated_at, public: true
  end

end
