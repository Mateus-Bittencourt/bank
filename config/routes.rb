Rails.application.routes.draw do
  devise_for :users
  root to: "users#show"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get 'account/:account_number', to: 'users#show', as: :user
  get 'account/:account_number/confirmation_destroy', to: 'users#confirmation_destroy', as: :user_confirmation_destroy
  delete "accounts/:id", to: "users#destroy", as: :user_soft_destroy
  # Defines the root path route ("/")
  # root "articles#index"
end
