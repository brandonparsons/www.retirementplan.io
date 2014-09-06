source 'https://rubygems.org'
ruby '2.1.2'

gem 'rails', '4.1.4'

gem "rack-reverse-proxy", require: "rack/reverse_proxy"

gem 'pg'

gem 'redis'
# gem 'redis-namespace'

gem 'sucker_punch'

gem 'split', require: 'split/dashboard'

gem 'faraday'
gem 'rack-rewrite'
gem 'builder' # sitemap.xml
gem 'gibbon'
gem 'figaro'


################
# View Related #
################
gem 'slim'
gem 'bootstrap-sass'
gem 'font-awesome-rails'

##############
# Javascript #
##############
gem 'jquery-rails'
gem 'fastclick-rails'

##########
# Assets #
##########
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'execjs'


group :production do
  gem 'unicorn'

  gem 'oj'
  gem 'kgio' # Speeds up dalli
  gem 'memcachier'
  gem 'dalli'

  gem 'heroku-deflater'
  gem 'rack-cache'
  gem 'rails_12factor'

  gem 'rollbar', require: 'rollbar/rails'
  gem 'newrelic_rpm'
end


group :development do
  gem 'thin'

  gem 'spring'

  gem 'hirb'
  gem 'awesome_print'

  gem 'pry'
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry-stack_explorer'
  gem 'pry-byebug'

  gem 'letter_opener'

  gem 'meta_request'
  gem "binding_of_caller"
  gem "better_errors"

  gem 'quiet_assets'

  gem 'guard'
  gem 'guard-livereload', require: false
end
