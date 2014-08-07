require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RetirementPlanIo
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Mountain Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    #########

    # Precompile additional assets.
    # application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
    config.assets.precompile += %w( vendor.js top.js bottom.js main.css vendor.css )

    # config.generators do |g|
    #   g.test_framework :rspec, :fixtures => true, :view_specs => false, :helper_specs => false, :routing_specs => false, :controller_specs => true, :request_specs => true
    #   g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    # end

    config.action_mailer.default_url_options = { host: ENV['MAILER_HOST'] }
    config.action_mailer.default_options = {from: "Admin [RetirementPlan.io] <admin@#{ENV['MAILER_HOST']}>"}

    # Autoload lib
    config.autoload_paths += Dir[Rails.root.join('lib', '{**/}')]

    # # Autoload all folders/subdirectories under app/models
    # config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**/}')]

    # # Autoload all folders under app - rails didn't want to autoload Finance::
    # # namespace stuff under app/finance/* otherwise.
    # config.autoload_paths << "#{config.root}/app"

    config.middleware.insert 0, 'Rack::Rewrite' do
      # rewrite   '/wiki/John_Trupiano',  '/john'
      # r301      '/wiki/Yair_Flicker',   '/yair'
      # r302      '/wiki/Greg_Jastrab',   '/greg'
      # r301      %r{/wiki/(\w+)_\w+},    '/$1'

      # BKP: Added on May-18-2014, Scott had incorrect spelling on title, had
      # already posted to Facebook before noticing.... Re-write here as can't control external links
      r301 '/blog/2014/05/want-good-retirement-planning-advice-ask-a-millenial', '/blog/2014-05-want-good-retirement-planning-advice-ask-a-millennial'

      # BKP: Old blog URL structure was /blog/YEAR/MONTH/SLUG, changing to /blog/YEAR-MONTH-SLUG
      r301 %r{  \/blog\/(\d{4})\/(\d{2})\/(.+)   }, '/blog/$1-$2-$3'
    end

  end
end
