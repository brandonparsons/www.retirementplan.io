class AssetClass
  include ActiveModel::Model
  attr_accessor :id, :description, :asset_type, :etfs

  def to_param
    @id
  end

  # FIXME: Extract this into finance.retirementplan.io, and return as part of API responses.
  def overview
    case id
    when "CDN-REALESTATE"
      "ETFs that provide exposure to the Canadian Real Estate market - broadly distributed across the country."
    when "COMMODITIES"
      "ETFs that provide exposure to various commodities - generally considered as input to a growing economy."
    when "US-LGCAP-STOCK"
      "ETFs that provide exposure to the equity of large, U.S. based companies."
    when "US-LONG-GOV-BOND"
      "ETFs that provide exposure to U.S. Government debt, with long maturities."
    when "INTL-REALESTATE"
      "ETFs that provide exposure to the International Real Estate market - broadly distributed across the globe."
    when "US-REALESTATE"
      "ETFs that provide exposure to the U.S. Real Estate market - broadly distributed across the country."
    when "US-SHORT-CORP-BOND"
      "ETFs that provide exposure to U.S. Corporate debt, with short maturities."
    when "CDN-LONG-BOND"
      "ETFs that provide exposure to Canadian Corporate debt, with long maturities."
    when "CDN-SHORT-BOND"
      "ETFs that provide exposure to Canadian Corporate debt, with short maturities."
    when "US-SMCAP-STOCK"
      "ETFs that provide exposure to the equity of smaller U.S. based companies."
    when "INTL-BOND"
      "ETFs that provide exposure to International Government & Corporate debt, with varying maturities."
    when "US-SHORT-GOVT-BOND"
      "ETFs that provide exposure to U.S. Government debt, with shorter maturities."
    when "US-MED-CORP-BOND"
      "ETFs that provide exposure to U.S. Corporate debt, with medium maturities."
    when "CDN-STOCK"
      "ETFs that provide exposure to the equity of Canadian companies."
    when "US-MED-GOV-BOND"
      "ETFs that provide exposure to U.S. Government debt, with medium maturities."
    when "EMERG-STOCK"
      "ETFs that provide exposure to the equity of companies based in countries classified as Emerging Markets."
    when "US-LONG-CORP-BOND"
      "ETFs that provide exposure to U.S. Corporate debt, with longer maturities."
    when "INTL-STOCK"
      "ETFs that provide exposure to the equity of companies based in Europe, Asia and the Far East (EAFE)."
    else
      raise "Asset class overview not prepared."
    end
  end

end
