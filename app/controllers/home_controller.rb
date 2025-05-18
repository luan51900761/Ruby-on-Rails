class HomeController < ApplicationController
  # No authentication required for the home page
  # If you want to require login to view the home page, remove this line
  skip_before_action :authenticate_user!, only: [:index]

  def index
    # Logic for the home page (if needed)
  end
end
