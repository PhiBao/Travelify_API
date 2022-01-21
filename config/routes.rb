Rails.application.routes.draw do
  root 'static_pages#home'
  
  post 'sessions/social_auth/callback', to: 'sessions#social_create'
  resources :sessions, only: :create
  resources :activation, only: %i[show update]
  resources :users, only: %i[create update show] do
    collection do
      get :forgotten_password
    end
    member do
      put :reset_password
      put :change_password
      get :bookings
      get :notifications
      put :read_all
    end
  end
  resources :tours, only: %i[show index] do
    member do
      get :mark
      get :reviews
    end
  end
  resources :checkout, only: :create
  resources :bookings, only: :create do
    member do
      post :review
    end
  end
  resources :webhooks, only: :create
  resources :reviews, only: :destroy do
    member do
      put :like
      put :toggle
      get :comments
      post :report
      post :comment
    end
  end
  resources :comments, only: :destroy do
    member do
      put :like
      put :toggle
      get :replies
      post :report
      post :reply
    end
  end
  namespace :admin do
    resources :dashboard, only: :index do
      collection do
        get :analytics
        get :revenues
        get :search
      end
    end
    resources :users, only: %i[index create update destroy]
    resources :tours, only: %i[index create update destroy]
    resources :bookings, only: %i[index create update destroy] do
      collection do
        get :helpers
      end
    end
    resources :tags, only: %i[index create update destroy]
  end
  resources :notifications, only: %i[index update destroy]

  mount ActionCable.server => '/cable'
  mount LetterOpenerWeb::Engine, at: '/letters' if Rails.env.development?
end
