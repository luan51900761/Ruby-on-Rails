require 'open-uri'

# app/controllers/purchases_controller.rb
class PurchasesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_customer

  def index
    @purchases = current_user.customer.purchases
  end

  def create
    asset = Asset.find_by(id: params[:asset_id]) # Use find_by to avoid errors if asset_id is invalid

    if asset.nil?
      redirect_to catalog_index_path, alert: "Asset not found." # catalog_index_path is an example
      return
    end

    # current_user.customer is ensured to exist by before_action :ensure_customer
    purchase = current_user.customer.purchases.new(
      asset: asset,
      purchase_date: Time.current
    # Add other attributes if needed, for example: price_at_purchase: asset.price
    )
    
    if purchase.save
      # Optional: you can perform other actions such as sending emails, updating statistics, etc.
      redirect_to downloads_path, notice: "Purchase successful! You can now download this asset."
    else
      # Error when saving purchase, usually due to validation
      # redirect_to asset_path(asset), alert: "Purchase failed: #{purchase.errors.full_messages.join(", ")}"
      # Or if you are on the asset detail page:
      redirect_back fallback_location: catalog_path(asset), alert: "Purchase failed: #{purchase.errors.full_messages.join(", ")}"
    end
  end
end

# app/controllers/downloads_controller.rb
class DownloadsController < ApplicationController
  # Đảm bảo người dùng đã đăng nhập
  before_action :authenticate_user!

  # Đảm bảo người dùng là customer
  before_action :ensure_customer

  # Hiển thị danh sách tất cả các assets đã mua để tải xuống
  def index
    @purchases = current_user.customer.purchases.includes(:asset)
  end

  # Xử lý việc tải xuống một asset cụ thể
  # Download functionality moved to DownloadsController

  private

  # Phương thức kiểm tra người dùng có phải là customer không
  def ensure_customer
    unless current_user.role == 'customer'
      redirect_to root_path, alert: "Only customers can access this page"
    end
  end
end
