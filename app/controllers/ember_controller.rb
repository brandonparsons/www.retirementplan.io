class EmberController < ApplicationController

  # Renders a fully-compiled index.html built by ember-cli, which uploads to
  # redis as part of the build/release process. Static files are loaded to S3
  # and know how to find themselves.
  def index
    render text: index_html
  end


  private

  def index_html
    if Rails.env.development?
      # Filler HTML content. Looks like sometimes we were requesting the production HTML content... No need to load the app anyway in dev.
      "<html><p>Development environment - placeholder for ember app index.html.....</p></html>"
    else
      $redis.get "#{deploy_key}:index.html"
    end
  end

  # By default serve release, if canary is specified then the latest
  # known release, otherwise the requested version.
  def deploy_key
    params[:version] ||= 'release'
    case params[:version]
    when 'release' then 'release'
    when 'canary'  then  $redis.lindex('releases', 0)
    else
      params[:version]
    end
  end

end
