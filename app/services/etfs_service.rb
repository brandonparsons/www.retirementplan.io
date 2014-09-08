module EtfsService

  extend self

  def all
    Rails.cache.fetch("etfs_service/etfs", expires_in: 12.hours) do
      get_as_objects.map do |etf|
        Etf.new(  id: etf.id, asset_id: etf.asset_id, description: etf.description, ticker: etf.ticker )
      end
    end
  end


  private

  def get_as_objects
    top_level = Hashie::Mash.new(JSON.parse(etfs_json))
    return top_level.etfs
  end

  def etfs_json
    conn = Faraday.new(url: ENV['FINANCE_APP'])
    conn.get do |req|
      req.url '/etfs'
      req.headers['Content-Type']   = 'application/json'
      req.headers['Authorization']  = ENV['AUTH_TOKEN']
    end.body
  end

end
