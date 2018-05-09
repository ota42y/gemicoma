Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'home#index'

  get 'auth/:provider/callback', to: 'sessions#callback'
  get '/logout', to: 'sessions#destroy'

  namespace :github do
    resources :repositories, only: [:new, :create]

    resources :users, only: [:show] do
      scope module: :users do
        resources :repositories, only: [:show]
      end
    end
  end
end
