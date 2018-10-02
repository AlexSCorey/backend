Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  resources :calendars, only: [:index, :create, :show, :update, :destroy] do
    resources :users, only: :index
  end


  resources :users, only: [:create, :edit, :update, :destroy]

  resources :logins, only: [:create]

  
end
