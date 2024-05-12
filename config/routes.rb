require_relative "../lib/constraints/username_route_contrainer"
require "sidekiq/web"

Rails.application.routes.draw do
  # devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root to: "home#index"

  get "/searchables", to: "users#index", as: :searchable_users
  # resource :oembed, controller: 'oembed', only: :show
  get "/oembed/", to: "oembed#show", as: :oembed
  get "/become/:id", to: "application#become"
  get "/artists", to: "users#index"
  
  get "/embed/:track_id", to: "embeds#show"
  get "/oembed/:track_id", to: "embeds#oembed_show", as: :oembed_show
  get "/oembed/:track_id/private", to: "embeds#oembed_private_show", as: :private_oembed_track
  get "/embed/:track_id/private", to: "embeds#private_track", as: :private_embed
  get "/embed/sets/:playlist_id", to: "embeds#show_playlist"
  get "/embed/sets/:playlist_id/private", to: "embeds#private_playlist"

  get "/404" => "errors#not_found"
  get "/500" => "errors#fatal"
  post "webhooks/:provider", to: "webhooks#create", as: :webhooks

  resource :player, controller: "player"

  scope path: "/api" do
    scope path: "/v1" do
      resources :direct_uploads, only: [:create], controller: "api/v1/direct_uploads"
      resources :audio_direct_uploads, only: [:create], controller: "api/v1/audio_direct_uploads"
    end
  end

  resources :articles do
    member do
      get :preview
    end
    collection do
      get :mine
    end
  end

  resources :purchases do
    collection do
      get :tickets
      get :music
    end
  end

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations: "users/registrations",
    sessions: "users/sessions"
    # :invitations => 'users/invitations'
  }

  resources :sales

  resources :event_webhooks

  get "/events/:id/livestream", to: "event_streaming_services#show", as: :event_livestream

  resources :events do
    collection do
      get :mine
    end
    member do
    end

    resources :event_hosts
    resources :event_recordings
    resources :event_tickets
    resources :event_streaming_services
    resources :event_purchases do
      member do
        get :success
        get :failure
      end
    end
  end

  get "/tracks/genre/:tag", to: "tags#index", as: :track_tag

  resources :tracks do
    resource :events, only: :show, controller: "tracking_events"
    resource :reposts
    resource :likes
    resources :comments
    resource :embed, only: :show
    resource :sharer, controller: "sharer"
    member do
      get :private, to: "tracks#private_access"
    end
    resources :track_purchases do
      member do
        get :success
        get :failure
      end
    end
  end

  resources :photos
  resource :spotlight
  resources :playlists do
    resources :comments
    resource :embed, only: :show
    resource :likes
    resource :reposts
    resource :sharer, controller: "sharer"
    member do
      post :sort
    end
  end

  resources :track_playlists

  authenticate :user, lambda { |u| u.is_admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  get "/onbehalf/parent/:username", to: "label_auth#back"
  get "/onbehalf/:username", to: "label_auth#add"
  
  resources :account_connections do
    collection do
      get :user_search
      get :impersonate
    end
    member do
      get :approve
      post :approve
    end
  end

  resources :labels

  constraints(Constraints::UsernameRouteConstrainer.new) do
    # Same route as before, only within the constraints block
    resources :users, path: "" do
      resource :insights
      resources :artists, controller: "label_artists"
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
      get "/playlists_filter", to: "users#playlists_filter"
      get "/reposts", to: "users#reposts"
      get "/albums", to: "users#albums"
      get "/about", to: "users#about"
      get "/articles", to: "users#articles"
    end
  end

  mount Plain::Engine => "/plain"
end
