Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'home#index'

  namespace :github do
    resources :repositories, only: [:new, :create]

    resources :users, only: [] do
      scope module: :users do
        resources :repositories, only: [:show]
      end
    end
  end
end
