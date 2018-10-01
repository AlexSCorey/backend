Rails.application.routes.draw do
  get 'logins/create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users, only: [:create]
  resources :logins, only: [:create]
  
end
