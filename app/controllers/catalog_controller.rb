# app/controllers/api/v1/catalog_controller.rb

class CatalogController < ApplicationController
  # Display a list of all available assets
  def index
    @assets = Asset.all
  end

  # Display details of a specific asset
  def show
    @asset = Asset.find(params[:id])
  end
end