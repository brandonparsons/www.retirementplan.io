class PostsController < ApplicationController
  layout :resolve_layout
  protect_from_forgery except: [:webhook_update]

  def index
    all_posts   = Post.all
    @posts      = paginated(all_posts)
    # @cache_key  = Post.cache_key_for_posts(@posts)
    fresh_when etag: @posts, public: true
  end

  def show
    @post = Post.find params[:id]
    redirect_to posts_path and return unless @post
    fresh_when etag: @post, last_modified: @post.updated_at, public: true
  end

  def feed
    expires_in(4.hours, public: true)
    respond_to do |format|
      format.xml
    end
  end

  def tag
    @tag    = params[:tag]
    posts   = Post.with_tag(@tag)
    @posts  = paginated(posts)
  end

  def webhook_update
    render json: {status: :unauthorized, message: "Invalid authentication token"} and return unless params[:auth_token] == ENV['WEBHOOK_AUTH_TOKEN']
    logger.warn "[WEBHOOK UPDATE]"
    logger.warn params.inspect
    PostUpdater.new.async.perform()
    render json: {status: :success, message: "Updating posts"}
  end


  private

  def resolve_layout
    action_name == "tag" ? "static" : "application"
  end

  def paginated(array)
    Kaminari.paginate_array(array).page(params[:page]).per(posts_per_page)
  end

  def posts_per_page
    params[:count] || 5
  end

end
