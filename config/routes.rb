Rails.application.routes.draw do
  get 'sessions/new'
  get 'users/new'
  get '/signup', to: 'users#new'

  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create'
  delete '/signout', to: 'sessions#destroy'

  root 'static_pages#home'

  resources :users
  resources :invitations, only: %i[create edit destroy]
  resources :projects do # , only: [:create, :edit, :destroy]
    resources :tasks # , only: [:create, :edit, :destroy]
  end
  resources :password_resets, only: %i[new create edit update]
  resources :account_activations, only: %i[new create edit update]
end
