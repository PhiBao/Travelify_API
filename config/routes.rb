Rails.application.routes.draw do
  resources :sessions, only: [:create]
  resources :activation, only: [:show, :update]
  resources :users, only: [:index, :create, :update, :show, :destroy] do
    collection do
      get 'forgotten_password'
    end
    member do
      put 'reset_password'
      put 'change_password'
    end
  end
  post 'sessions/social_auth/callback', to: 'sessions#social_create'
  resources :tours, only: [:create, :update, :destroy, :index]
  resources :vehicles, only: [:index]

  mount LetterOpenerWeb::Engine, at: "/letters" if Rails.env.development?
end
