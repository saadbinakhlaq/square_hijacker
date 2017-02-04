Rails.application.routes.draw do
  root 'games#index'

  resources :games, only: [:index, :show, :create, :new] do
    member do
      put :join
    end

    resources :players, only: [:new, :create]
  end
end
