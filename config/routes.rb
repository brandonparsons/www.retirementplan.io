Rails.application.routes.draw do

  root                to: 'pages#home'
  get '/about',       to: 'pages#about',        as: :about
  get '/disclosures', to: 'pages#disclosures',  as: :disclosures
  get '/privacy',     to: 'pages#privacy',      as: :privacy
  get '/terms',       to: 'pages#terms',        as: :terms

  get '/sitemap.xml', to: 'misc#sitemap', as: :sitemap, defaults: {format: 'xml'}
  get '/error'      , to: 'misc#error'
  get '/health'     , to: 'misc#health'

  get '/app',       to: 'ember#index'
  get '/app*',      to: 'ember#index'
  get '/app/*foo',  to: 'ember#index'

  scope :api do
    match '/*anything', to: 'proxy#api', via: [:get, :post, :put, :patch, :delete], format: false
  end

  Split::Dashboard.use Rack::Auth::Basic do |username, password|
    username == ENV['ADMIN_USER'] && password == ENV['ADMIN_PASSWORD']
  end
  mount Split::Dashboard, :at => 'split'

  scope :blog do
    get "/"                       => 'posts#index', as: :posts
    get "/page/:page"             => 'posts#index'

    get "/tags/:tag"              => 'posts#tag', as: :tags
    get "/tags/:tag/page/:page"   => 'posts#tag'

    get "/feed.xml" => 'posts#feed',  as: :posts_feed, defaults: {format: 'xml'}

    get "/:id" => 'posts#show'

    post '/update' => 'posts#webhook_update'
  end

end
