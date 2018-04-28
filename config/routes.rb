Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :github do
    resources :repositories, only: [:create]

    resources :users, only: [] do
      resources :repositories, only: [:show]
    end
  end
end
