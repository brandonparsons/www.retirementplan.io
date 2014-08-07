if Rails.env.test?
  redis_server_url = ENV.fetch('REDIS_SERVER', 'redis://localhost:6379')
  $redis = Redis.new url: redis_server_url, db: 2

elsif Rails.env.development?
  redis_server_url = ENV.fetch('REDIS_SERVER', 'redis://localhost:6379')
  $redis = Redis.new url: redis_server_url, db: 0

else # production / staging
  redis_server_url = ENV['REDISCLOUD_URL'] || ENV['REDIS_SERVER']
  if redis_server_url.present?
    # Won't exist if we haven't set it (Heroku precompile etc)
    $redis = Redis.new url: redis_server_url
  else
    puts "\n*****************"
    puts "WARNING: MISSING REDIS_SERVER"
    puts "*****************\n"
  end
end
