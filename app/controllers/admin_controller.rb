# app/controllers/api/v1/admin_controller.rb
class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin

  def creator_earnings
    # First, let's log the SQL that's actually being generated
    query = Creator
              .joins("LEFT JOIN assets ON assets.creator_id = creators.id")
              .joins("LEFT JOIN purchases ON purchases.asset_id = assets.id")
              .group("creators.id")
              .select("creators.id AS creator_id, COALESCE(SUM(assets.price), 0) AS total_earnings")
    
    Rails.logger.debug "QUERY SQL: #{query.to_sql}"
    
    # Try to execute with our ActiveRecord approach first
    earnings_ar = query.to_a
    
    # Log the results for debugging
    Rails.logger.debug "AR RESULTS: #{earnings_ar.inspect}"
    
    # let's try direct SQL execution as a fallback
    if earnings_ar.all? { |e| e.total_earnings.to_f == 0 }
      # Use connection.select_all to execute raw SQL
      sql = <<-SQL
        SELECT
          creators.id AS creator_id,
          COALESCE(SUM(assets.price), 0) AS total_earnings
        FROM creators
        LEFT JOIN assets ON assets.creator_id = creators.id
        LEFT JOIN purchases ON purchases.asset_id = assets.id
        GROUP BY creators.id
      SQL
      
      earnings_sql = ActiveRecord::Base.connection.select_all(sql)
      Rails.logger.debug "SQL RESULTS: #{earnings_sql.inspect}"
      
      # Format the results to match the expected output
      earnings = earnings_sql.map do |row|
        {
          creator_id: row['creator_id'], 
          total_earnings: row['total_earnings'].to_f
        }
      end
    else
      # Use the ActiveRecord results if they worked
      earnings = earnings_ar.map do |e| 
        { 
          creator_id: e.creator_id, 
          total_earnings: e.total_earnings.to_f 
        } 
      end
    end
    
    render json: earnings

  end

  private

  def ensure_admin
    unless current_user.role == 'admin'
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
