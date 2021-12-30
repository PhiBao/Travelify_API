Rails.application.routes.draw do
  root 'static_pages#home'
  resources :sessions,    only: [:create]
  resources :activation,  only: [:show, :update]
  resources :users,       only: [:index, :create, :update, :show, :destroy] do
    collection do
      get 'forgotten_password'
    end
    member do
      put 'reset_password'
      put 'change_password'
    end
  end
  post 'sessions/social_auth/callback', to: 'sessions#social_create'
  resources :tours,     only: [:show, :create, :update, :destroy, :index]
  resources :helpers,   only: [:index]
  resources :bookings,  only: [:create]
  post '/checkout',     to: 'checkout#create'
  resources :webhooks,  only: :create
  get '/success',       to: 'checkout#success'
  get '/cancel',        to: 'checkout#cancel'

  mount LetterOpenerWeb::Engine, at: '/letters' if Rails.env.development?
end
