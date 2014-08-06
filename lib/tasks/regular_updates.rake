task :regular_update => [:get_simulation_count]

desc "Loads simulation count from app server"
task get_simulation_count: :environment do
  require 'json'

  puts "Grabbing simulation count"

  response = Faraday.new(url: ENV['API'] + '/simulation_count').get

  json                  = JSON.parse response.body
  number_of_simulations = json['simulations']

  puts "Setting simulation count to #{number_of_simulations}"
  $redis.set $SIMULATION_COUNT_KEY, number_of_simulations
end
