Rails.application.routes.draw do
  devise_for :users
  root to: "users#show"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get '/', to: 'users#show', as: :user
  get '/confirmation_destroy', to: 'users#confirmation_destroy', as: :user_confirmation_destroy
  delete "accounts/:id", to: "users#destroy", as: :user_soft_destroy
  get '/transactions/deposit', to: 'transactions#deposit', as: :deposit
  post '/transactions/deposit', to: 'transactions#save_deposit', as: :save_deposit
  get '/transactions/withdraw', to: 'transactions#withdraw', as: :withdraw
  post '/transactions/withdraw', to: 'transactions#save_withdraw', as: :save_withdraw
  get '/transactions/transfer_between_accounts', to: 'transactions#transfer_between_accounts', as: :transfer_between_accounts
  post '/transactions/transfer_between_accounts', to: 'transactions#save_transfer_between_accounts', as: :save_transfer_between_accounts
  # get 'account/:account_number/transactions/account_statement', to: 'transactions#account_statement', as: :account_statement

  resources :transactions, only: :index
  # Defines the root path route ("/")
  # root "articles#index"
end
