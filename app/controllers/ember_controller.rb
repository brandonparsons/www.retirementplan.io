class EmberController < ApplicationController

  # Renders a fully-compiled index.html built by ember-cli, which uploads to
  # redis as part of the build/release process. Static files are loaded to S3
  # and know how to find themselves.
  def index
    render text: index_html
  end

  # Basically a no-op in case you want to track sign-ins in the future, and to
  # make URL consistent with sign_up
  def sign_in
    redirect_to ENV['SIGN_IN_PATH']
  end

  # Completes any signup A/B tests prior to forwarding on
  def sign_up
    finished("home_page_button_colour")
    redirect_to ENV['SIGN_UP_PATH']
  end


  private

  def index_html
    $redis.get "#{deploy_key}:index.html"
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
