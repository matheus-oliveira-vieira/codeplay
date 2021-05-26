Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :courses, only: %i[index show]
end
