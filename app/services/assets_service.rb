module AssetsService

  extend self

  def all
    Rails.cache.fetch("assets_service/asset_classes", expires_in: 12.hours) do
      get_as_objects.map do |asset_class|
        AssetClass.new( id: asset_class.id, description: asset_class.asset_class, asset_type: asset_class.asset_type )
      end
    end
  end


  private

  def get_as_objects
    top_level = Hashie::Mash.new(JSON.parse(assets_json))
    return top_level.assets
  end

  def assets_json
    conn = Faraday.new(url: ENV['FINANCE_APP'])
    conn.get do |req|
      req.url '/assets'
      req.headers['Content-Type']   = 'application/json'
      req.headers['Authorization']  = ENV['AUTH_TOKEN']
    end.body
  end

end
