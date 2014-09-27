class EtfsController < ApplicationController

  def show
    all_etfs = EtfsService.all

    # Some tickers have a `.` in them - e.g. XRE.TO
    ticker = params[:format].present? ? "#{params[:id]}.#{params[:format]}" : params[:id]

    @etf = all_etfs.select{|etf| etf.ticker == ticker}.first

    # Used to route by etf UUID, which was ugly. Keep the lookup here to not break
    # those old routes
    if @etf.nil?
      @etf = all_etfs.select{|etf| etf.id == ticker}.first
    end

    @asset_class  = AssetsService.all.select{|asset_class| asset_class.id == @etf.asset_id}.first
    @data         = YahooFinanceService.new(@etf.ticker).data

    gon.dates         = @data.dates
    gon.close_prices  = @data.close_prices
  end

end
