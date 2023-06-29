Rails.application.routes.draw do
  get '/signup', to: 'users#new'

  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create'
  delete '/signout', to: 'sessions#destroy'

  root 'static_pages#home'

  resources :users, only: %w[new create]
  resources :invitations, only: %i[create edit]
  resources :projects do
    resources :tasks, only: %i[new create edit update destroy]
  end
  resources :password_resets, only: %i[new create edit update]
  resources :account_activations, only: %i[new create edit update]
end
