class Etf
  include ActiveModel::Model
  attr_accessor :id, :asset_id, :description, :ticker

  def to_param
    @id
  end

end
