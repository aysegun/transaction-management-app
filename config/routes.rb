# Rails.application.routes.draw do
#   # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

#   # Defines the root path route ("/")
#   # root "articles#index"
#   resources :clients do
#     resources :transactions, only: %i[new show index] do
#       post 'transactions/create_expense', to: 'transactions#create_expense', as: :create_expense
#       post 'transactions/create_payment', to: 'transactions#create_payment', as: :create_payment
#       delete 'transactions/:id', to: 'transactions#destroy', as: :destroy_transaction
#     end
#   end

#   root 'clients#new'
# end

Rails.application.routes.draw do
  resources :clients do
    get 'transactions/new', to: 'transactions#new'
    post 'transactions/create_expense', to: 'transactions#create_expense', as: :create_expense
    post 'transactions/create_payment', to: 'transactions#create_payment', as: :create_payment
    delete 'transactions/:id', to: 'transaction#destroy', as: :destroy_transaction
  end

  root 'clients#new'
end
