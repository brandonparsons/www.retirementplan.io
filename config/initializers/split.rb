namespace       = ["split", "rp-marketing", Rails.env].join(":")
redis_namespace = Redis::Namespace.new(namespace, redis: $redis)
Split.redis     = redis_namespace


Split.configure do |config|
  config.db_failover                = true # handle redis errors gracefully
  config.db_failover_on_db_error    = proc{|error| Rails.logger.error(error.message) }
  config.allow_multiple_experiments = true # It's fine for me, but might not for you
  config.enabled                    = true
  # config.persistence = Split::Persistence::RedisAdapter.with_config(lookup_by: :current_user_id }
  # config.algorithm = Split::Algorithms::Whiplash

  ## Default is ignore bots & IPs
  # config.ignore_filter = proc{ |request| CustomExcludeLogic.excludes?(request) }

  config.experiments = {

    "home_page_button_colour" => {
      alternatives: [
        "btn-orange",
        "btn-green"
      ],
      resettable: false,
      metric: :sign_up,
    },

    "blog_sidebar_newsletter_text" => {
      alternatives: [
        'Ready to learn more about personal finance and retirement planning?',
        'Sign up for free educational information and product updates!'
      ],
      resettable: false,
      metric: :blog_driven_newsletter_signup,
    },

    # Old tests that are gone from list:
    #
    # Main header copy:
    #   "Discover the retirement planning tool you should have had all along." ***
    #   "It's time to retire the old way of retiring."
    #   "Just connect and retire your old idea of retiring."
    #
    # Main header image:
    #  Laptop screenshot
    #  Pic of family ***
    #  Pic of young couple
    #  Pic of lady looking up and right

  }

end
