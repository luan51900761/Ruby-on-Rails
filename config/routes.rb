# config/routes.rb
Rails.application.routes.draw do
  # Define a root path
  root "home#index"

  # assets routes
  resources :assets do
    collection do
      get :bulk_import
      post :process_bulk_import
    end
  end

  # Admin routes
  get 'admin/creator_earnings', to: 'admin#creator_earnings', as: 'creator_earnings'
  
  # catalog routes
  resources :catalog, only: [:index, :show]

  # Routes for purchases
  resources :purchases, only: [:index, :create]

  # Routes for downloads
  get 'downloads', to: 'downloads#index'
  get 'downloads/:id', to: 'downloads#download', as: 'download'
  get 'download_file/:id', to: 'downloads#download', as: 'download_file'

  # Session routes
  get '/login', to: 'sessions#new', as: 'login' # as: 'login' to have login_path
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: 'logout'
end
