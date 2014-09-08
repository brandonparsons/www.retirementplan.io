class AssetClassesController < ApplicationController

  def index
    @asset_classes_by_type = AssetsService.all.group_by{|asset_class| asset_class.asset_type}
  end

  def show
    asset_id = params[:id]
    @asset_class = AssetsService.all.select{|asset_class| asset_class.id == asset_id}.first
    @asset_class.etfs = EtfsService.all.select{|etf| etf.asset_id == asset_id}
  end

end
