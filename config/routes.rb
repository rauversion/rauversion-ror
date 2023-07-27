require_relative "../lib/constraints/username_route_contrainer.rb"

Rails.application.routes.draw do
  # devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root to: "home#index"

  resources :articles do
    collection do
      get :mine
    end
  end

  scope path: '/api' do
    scope path: '/v1' do
      resources :direct_uploads, only: [:create], controller: 'api/v1/direct_uploads'
    end
  end

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    :registrations => "users/registrations",
    :sessions => 'users/sessions',
    # :invitations => 'users/invitations'
  }

  resources :events do 
    collection do
      get :mine
    end
    member do

    end

    resources :event_hosts
    resources :event_recordings
  end

  resources :tracks do
    resource :events, only: :show, controller: "tracking_events"
    resource :reposts
    resource :likes
  end

  resources :playlists

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
