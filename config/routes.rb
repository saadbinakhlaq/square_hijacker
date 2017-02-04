Rails.application.routes.draw do
  root 'games#index'

  resources :games, only: [:index, :show, :create, :new] do
    member do
      put :join
    end

    resources :players, only: [:new, :create]

    resources :squares, only: [] do
      member do
        put :claim
      end
    end
  end
end
