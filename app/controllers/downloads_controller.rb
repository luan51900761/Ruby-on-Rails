require 'open-uri'
require 'mime/types'

class DownloadsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_customer, only: [:index, :download]
  
  def index
    @purchases = current_user.customer.purchases.includes(:asset)
  end
  
  def show
    @download = current_user.customer.purchases.find(params[:id])
  end
  
  def download
    @purchase = current_user.customer.purchases.find_by(id: params[:id])
    
    if @purchase.nil?
      redirect_to downloads_path, alert: "Purchase not found or you don't have permission to access it."
      return
    end
    
    # Download the file from the asset's URL
    begin
      asset = @purchase.asset
      original_url = asset.file_url
      
      # Extract file extension from URL
      uri = URI.parse(original_url)
      file_extension = File.extname(uri.path).downcase
      
      # If no extension in URL, try to determine from content type or URL pattern
      if file_extension.blank?
        file_extension = '.png' if original_url.include?('png')
        file_extension = '.jpg' if original_url.include?('jpg') || original_url.include?('jpeg')
        file_extension = '.mp3' if original_url.include?('mp3')
        file_extension = '.pdf' if original_url.include?('pdf')
        # Add more extensions as needed
      end
      
      # Use a default extension if none could be determined
      file_extension = '.bin' if file_extension.blank?
      
      # Determine MIME type based on file extension
      mime_type = MIME::Types.type_for(file_extension).first&.content_type || 'application/octet-stream'
      
      # Download file content from external URL
      file_data = URI.open(original_url, "rb", &:read) # "rb" to read binary
      
      # Create proper filename with extension
      filename = "#{asset.title}#{file_extension}"
      
      send_data(
        file_data,
        filename: filename,
        type: mime_type,
        disposition: 'attachment'
      )
    rescue OpenURI::HTTPError => e
      Rails.logger.error "Error downloading external file #{asset.file_url}: #{e.message}"
      redirect_to downloads_path, alert: "Could not download file: #{e.message}"
    rescue SocketError => e # DNS or connection errors
      Rails.logger.error "Network error downloading external file #{asset.file_url}: #{e.message}"
      redirect_to downloads_path, alert: "Could not connect to download the file."
    rescue StandardError => e
      Rails.logger.error "Unexpected error downloading external file #{asset.file_url}: #{e.message}"
      redirect_to downloads_path, alert: "An unexpected error occurred while downloading the file."
    end
  end
  
  private
  
  # Method to check if the user is a customer
  def ensure_customer
    unless current_user.role == 'customer'
      redirect_to root_path, alert: "Only customers can access this page"
    end
  end
end
