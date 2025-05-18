class AssetsController < ApplicationController
  skip_forgery_protection only: [:process_bulk_import]
   before_action :authenticate_user!
   before_action :ensure_creator

  def index
    @assets = current_user.creator.assets
  end

  def new
    @asset = Asset.new
  end

  def bulk_import
    # Display JSON upload form
  end

  def process_bulk_import
    begin
      unless current_user
        # render json: { error: "Unauthorized" }, status: :unauthorized # API example
        # redirect_to login_path, alert: "You need to log in." # Web example
        return
      end

      file = params[:json_file]
      if file.present?
        json_data = JSON.parse(file.read)

        creator = current_user.creator # Or your relationship name

        if creator.present?
          begin
            ActiveRecord::Base.transaction do
              json_data.each do |asset_data|
                current_user.creator.assets.create!(
                  title: asset_data['title'],
                  description: asset_data['description'],
                  file_url: asset_data['file_url'],
                  price: asset_data['price']
                )
              end
            end
            # Successful processing
            # render json: { message: "Asset created successfully!", asset: asset }, status: :created
            # redirect_to some_path, notice: "Asset has been created!"
          rescue ActiveRecord::RecordInvalid => e
            # Handle validation errors
            # render json: { error: "Failed to create asset", details: e.record.errors.full_messages }, status: :unprocessable_entity
            # redirect_to some_path, alert: "Error: #{e.record.errors.full_messages.join(', ')}"
          end

        else
          # User does not have a creator profile
          redirect_to bulk_import_assets_path, alert: "User is not creator"
          # render json: { error: "Creator profile not found." }, status: :forbidden
          # redirect_to new_creator_profile_path, alert: "You need to complete your creator profile."
        end

        redirect_to assets_path, notice: "\#{json_data.size} assets imported successfully"
      else
        redirect_to bulk_import_assets_path, alert: "No file selected"
      end
    rescue JSON::ParserError
      redirect_to bulk_import_assets_path, alert: "Invalid JSON format"
    rescue => e
      redirect_to bulk_import_assets_path, alert: "Error: \#{e.message}"
    end
  end

  private

  def ensure_creator
    unless current_user.role == 'creator'
      redirect_to root_path, alert: "Only creators can access this page"
    end
  end
end

