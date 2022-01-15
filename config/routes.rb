Rails.application.routes.draw do
  root 'static_pages#home'
  post '/checkout', to: 'checkout#create'
  post 'sessions/social_auth/callback', to: 'sessions#social_create'
  resources :sessions, only: :create
  resources :activation, only: %i[show update]
  resources :users, only: %i[create update show] do
    collection do
      get 'forgotten_password'
    end
    member do
      put 'reset_password'
      put 'change_password'
      get 'bookings'
    end
  end
  resources :tours, only: %i[show index] do
    member do
      get 'mark'
      get 'reviews'
    end
  end
  resources :bookings, only: :create do
    member do
      post 'review'
    end
  end
  resources :webhooks, only: :create
  resources :reviews, only: %i[create destroy] do
    member do
      get 'like'
      get 'hide'
      get 'appear'
      get 'comments'
      post 'report'
      post 'comment'
    end
  end
  resources :comments, only: :destroy do
    member do
      get 'like'
      get 'hide'
      get 'appear'
      get 'replies'
      post 'report'
      post 'reply'
    end
  end
  namespace :admin do
    resources :dashboard, only: :index do
      collection do
        get 'analytics'
        get 'revenues'
        get 'search'
      end
    end
    resources :users, only: %i[index create destroy]
    resources :tours, only: %i[index create update destroy]
  end

  mount LetterOpenerWeb::Engine, at: '/letters' if Rails.env.development?
end
