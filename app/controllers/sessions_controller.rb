# app/controllers/sessions_controller.rb

class SessionsController < ApplicationController
  # No login required to access the login page
  skip_before_action :authenticate_user!, only: [:new, :create], if: -> { respond_to?(:authenticate_user!) }

  def new
    # Only display the login page
    # If user is already logged in, redirect to the main page
    redirect_to root_path, notice: "You are already logged in!" if current_user
  end

  def create
    email = params[:email].to_s.strip.downcase
    password = params[:password].to_s

    # Find user by email (case insensitive)
    user = User.where("lower(email) = ?", email).first
  
    if user.nil?
      flash.now[:alert] = "Email or password is incorrect"
      return render :new, status: :unprocessable_entity
    end
  
    # Check password
    if user.authenticate(password)
      # Login successful
      session[:user_id] = user.id
  
      # Redirect based on role
      redirect_to after_login_path(user), notice: "Login successful!"
    else
      # Password incorrect
      flash.now[:alert] = "Email or password is incorrect"
      render :new, status: :unprocessable_entity
    end
  rescue => e
    # Error handling
    Rails.logger.error "Login error: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    flash.now[:alert] = "An error occurred during login: #{e.message}"
    render :new, status: :unprocessable_entity
  end

  def destroy
    # Logout
    session.delete(:user_id)
    @current_user = nil
    redirect_to root_path, notice: "Logged out successfully!"
  end

  private

  # Redirect user after successful login
  def after_login_path(user)
    case user.role
    when 'admin'
      # Redirect to admin page
      admin_path
    when 'creator'
      # Redirect to creator page
      creator_path
    else
      # Default redirect to home page
      root_path
    end
  rescue
    # If route doesn't exist, default to home page
    root_path
  end
end
