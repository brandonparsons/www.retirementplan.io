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

    # "main_header_copy" => {
    #   alternatives: [
    #     "Discover the retirement planning tool you should have had all along.",
    #     "It's time to retire the old way of retiring.",
    #     "Just connect and retire your old idea of retiring."
    #   ],
    #   resettable: false
    # },

    # "main_header_image" => {
    #   alternatives: [
    #     'home/main-screenshot.png',
    #     'home/main-screenshot-1.jpg',
    #     'home/main-screenshot-2.jpg',
    #     'home/main-screenshot-3.jpg',
    #     'home/main-screenshot-4.jpg'
    #   ],
    #   resettable: false
    # }

  }

end
