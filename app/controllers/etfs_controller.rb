class EtfsController < ApplicationController

  def show
    @etf          = EtfsService.all.select{|etf| etf.id == params[:id]}.first
    @asset_class  = AssetsService.all.select{|asset_class| asset_class.id == @etf.asset_id}.first
    @data         = YahooFinanceService.new(@etf.ticker).data

    gon.dates         = @data.dates
    gon.close_prices  = @data.close_prices
  end

end
