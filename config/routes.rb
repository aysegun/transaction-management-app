Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :clients do
    resources :transactions
  end

  root 'clients#new'

  post 'clients/:id/transactions/new', to: 'transactions#create_expense'
  post 'clients/:id/transactions/new', to: 'transactions#create_payment'
end
