Rails.application.routes.draw do
  get "password_resets/new"
  get "password_resets/edit"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "/signup", to: "users#new", as: "signup"

  get "password_resets", to: redirect("/password_resets/new")

  resources :password_resets, only: [ :new, :create, :edit, :update ]

  resources :users, only: [ :edit, :update ] do
    member do
      get :edit_password
      patch :update_password
    end
  end

  resources :users do
    resources :friendships
  end

  resources :users do
    member do
      get :upload_photo
      patch :upload_photo
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :expenses

  root "sessions#new"
end
