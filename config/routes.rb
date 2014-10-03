Rails.application.routes.draw do

  #################
  # CONTENT PAGES #
  #################

  root                to: 'pages#home'
  get '/health',      to: 'pages#health'

  get '/pricing', to: 'pages#pricing', as: :pricing
  get '/thanks',  to: 'pages#thanks', as: :thanks

  get '/about',                 to: 'pages#about',                  as: :about
  get '/our-video',             to: 'pages#our_video',              as: :video
  get '/asset-allocation',      to: 'pages#asset_allocation',       as: :asset_allocation
  get '/retirement-planning',   to: 'pages#retirement_planning',    as: :retirement_planning
  get '/instant-notification',  to: 'pages#instant_notification',   as: :instant_notification
  get '/security',              to: 'pages#security',               as: :security
  get '/tour',                  to: 'pages#tour',                   as: :tour

  get '/disclosures',           to: 'pages#disclosures',            as: :disclosures
  get '/privacy',               to: 'pages#privacy',                as: :privacy
  get '/terms',                 to: 'pages#terms',                  as: :terms

  get '/sitemap.xml', to: 'pages#sitemap', as: :sitemap, defaults: {format: 'xml'}

  resources :asset_classes, only: [:index, :show], path: 'asset-classes'
  resources :etfs,          only: [:show]


  ################################
  # MARKETING SITE FUNCTIONALITY #
  ################################

  post '/error', to: 'misc#error'


  ## POST calls ##
  post '/mailing_list_subscribe', to: 'misc#mailing_list_subscribe'


  #####################
  # EMBER APPLICATION #
  #####################

  get '/app',       to: 'ember#index'
  get '/app*',      to: 'ember#index'
  get '/app/*foo',  to: 'ember#index'


  #########
  # ADMIN #
  #########

  Split::Dashboard.use Rack::Auth::Basic, "Split" do |username, password|
    username == ENV['ADMIN_USER'] && password == ENV['ADMIN_PASSWORD']
  end
  mount Split::Dashboard, at: 'split'

end
