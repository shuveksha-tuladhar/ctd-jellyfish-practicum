Rails.application.routes.draw do
  get "home/index"
  get "password_resets/new"
  get "password_resets/edit"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "/signup", to: "users#new", as: "signup"

  get "password_resets", to: redirect("/password_resets/new")

  resources :password_resets, only: [ :new, :create, :edit, :update ]

  resources :users, only: [ :new, :create, :index, :show, :edit, :update, :destroy ] do
    member do
      get :edit_password
      patch :update_password
      get :upload_photo
      patch :upload_photo
    end

    resources :friendships
    resources :payments
    resources :balances, only: [ :index ]
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :expenses

  resources :user_groups do
    resources :group_members, only: [ :index, :create, :destroy ]
  end

  get "dashboard", to: "dashboard#index", as: :dashboard

  root "home#index"
end
