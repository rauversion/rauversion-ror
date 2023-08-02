require_relative "../lib/constraints/username_route_contrainer.rb"

Rails.application.routes.draw do
  # devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root to: "home#index"

  scope path: '/api' do
    scope path: '/v1' do
      resources :direct_uploads, only: [:create], controller: 'api/v1/direct_uploads'
    end
  end

  resources :articles do
    collection do
      get :mine
    end
  end

  resources :playlists do
    resources :comments
    resource :embed, only: :show
  end

  resources :purchases do
    collection do
      get :tickets
      get :music
    end
  end

  post "webhooks/:provider", to: "webhooks#create", as: :webhooks

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    :registrations => "users/registrations",
    :sessions => 'users/sessions',
    # :invitations => 'users/invitations'
  }

  resources :sales

  resources :events do 
    collection do
      get :mine
    end
    member do

    end

    resources :event_hosts
    resources :event_recordings
    resources :event_tickets
    resources :event_purchases do
      member do
        get :success
        get :failure
      end
    end
  end

  resources :tracks do
    resource :events, only: :show, controller: "tracking_events"
    resource :reposts
    resource :likes
    resources :comments
    resource :embed, only: :show
  end

  constraints(Constraints::UsernameRouteConstrainer.new) do
    # Same route as before, only within the constraints block
    resources :users, path: "" do
      resource :insights
      resources :settings, param: :section, controller: "user_settings"
      resources :invitations, controller: "user_invitations"
      resources :integrations, controller: "user_integrations"
      resources :reposts, controller: "user_reposts", only: [:create]
      resources :follows, controller: "user_follows", only: [
        :index, :create, :destroy
      ]
      get "followers", to: "user_follows#followers"
      get "followees", to: "user_follows#followees"
      get "/tracks", to: "users#tracks"
      get "/playlists", to: "users#playlists"
      get "/reposts", to: "users#reposts"
      get "/albums", to: "users#albums"
    end
  end
end
