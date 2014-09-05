# This file is used by Rack-based servers to start the application.

use Rack::ReverseProxy do
  reverse_proxy /^\/blog\/?(.*)$/, "#{ENV['BLOG_HOST']}/$1"
end

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application
