Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  resources :calendars, only: [:index, :create, :show, :update, :destroy] do
    resources :shifts, only: [:create, :update, :destroy]
    resources :users, only: [:index] do
      resource :role, only: [:create, :destroy]
    end
  end

  resources :users, only: [:create, :edit, :update]

  resources :logins, only: [:create]

  
end
