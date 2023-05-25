Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  post 'blobs/create', to: 'blobs#create'

  resources :blobs, only: %i[index show destroy]
end
