Rails.application.routes.draw do

  ##########
  # STATIC #
  ##########

  root                to: 'pages#home'
  get '/about',       to: 'pages#about',        as: :about
  get '/disclosures', to: 'pages#disclosures',  as: :disclosures
  get '/privacy',     to: 'pages#privacy',      as: :privacy
  get '/terms',       to: 'pages#terms',        as: :terms


  ################################
  # MARKETING SITE FUNCTIONALITY #
  ################################

  get '/health', to: 'misc#health'
  post '/error', to: 'misc#error'

  get '/sitemap.xml', to: 'misc#sitemap', as: :sitemap, defaults: {format: 'xml'}

  get '/sign_in', to: 'misc#sign_in', as: :sign_in
  get '/sign_up', to: 'misc#sign_up', as: :sign_up

  post '/mailing_list_subscribe', to: 'misc#mailing_list_subscribe'

  post '/complete_sign_in_tests',         to: 'misc#complete_sign_in_tests'


  #####################
  # EMBER APPLICATION #
  #####################

  get '/app',       to: 'ember#index'
  get '/app*',      to: 'ember#index'
  get '/app/*foo',  to: 'ember#index'


  #######
  # API #
  #######

  # We are running the API through the www. site to avoid having to worry about
  # CORS. Proxying to backend api.retirementplan.io server
  scope :api do
    match '/*anything', to: 'proxy#api', via: [:get, :post, :put, :patch, :delete], format: false
  end


  #########
  # ADMIN #
  #########

  Split::Dashboard.use Rack::Auth::Basic, "Split" do |username, password|
    username == ENV['ADMIN_USER'] && password == ENV['ADMIN_PASSWORD']
  end
  mount Split::Dashboard, at: 'split'

end
