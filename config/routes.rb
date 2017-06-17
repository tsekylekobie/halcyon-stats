Rails.application.routes.draw do
  resources :matches
  resources :rosters
  resources :participants
  resources :players, param: :ign
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
end
