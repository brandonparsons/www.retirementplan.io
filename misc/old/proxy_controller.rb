class ProxyController < ApplicationController
  def api
    conn = Faraday.new(url: ENV['API']) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    response = conn.run_request(
      request.method_symbol,
      request.fullpath,
      request.body.read,
      request.headers.select{|k,v| v.respond_to?(:strip)}
    )

    render text: response.body, status: response.status, content_type: response.headers["Content-Type"]
  end
end
