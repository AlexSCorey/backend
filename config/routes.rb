Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :calendars, only: [:index, :create, :show, :update, :detroy]

  resources :users, only: [:create, :edit, :update, :index, :destroy]

  resources :logins, only: [:create]

  
end
