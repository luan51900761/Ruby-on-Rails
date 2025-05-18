# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # Method to check if the user is logged in
  def authenticate_user!
    unless current_user
      redirect_to login_path, alert: "Please log in to access this page."
    end
  end
  helper_method :authenticate_user! # If you want to call it from view, although rarely used

  # Method to get current user information
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  # Method to check if the user is a customer
  def ensure_customer
    unless current_user&.role == 'customer'
      redirect_to root_path, alert: "Only customers can access this page."
    end
  end
  helper_method :ensure_customer

  # Method to check if the user is a creator
  def ensure_creator
    unless current_user&.role == 'creator'
      redirect_to root_path, alert: "Only creators can access this page."
    end
  end
  helper_method :ensure_creator

  # Method to check if the user is an admin
  def ensure_admin
    unless current_user&.role == 'admin'
      redirect_to root_path, alert: "Only admins can access this page."
    end
  end
  helper_method :ensure_admin

  def logged_in?
    current_user.present?
  end
end