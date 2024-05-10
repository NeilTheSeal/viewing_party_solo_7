Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  root "welcome#index"
  get "/register", to: "users#new", as: "register_user"

  resources :users, only: %i[show create] do
    resources :discover, only: %i[index]
    resources :movies, only: %i[index]
  end
end
