Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  resources :calendars, only: [:index, :create, :show, :update, :destroy] do

    resources :swaps, only: [:index, :update]

    resources :shifts, only: [:create, :update, :destroy] do
      resources :swaps, only: [:create]
      resources :usershifts, only: [:create, :destroy]
    end

    resource :invitation, only: [:create]

    resources :users, only: [:index] do
      resource :role, only: [:create, :destroy]
    end

    resources :notes, only: [:index, :create]

  end

  post 'invitations/complete', action: :complete, controller: 'invitations'
  post 'swaps/complete', action: :complete, controller: 'swaps'

  resources :users, only: [:create, :edit, :update]

  resources :logins, only: [:create]

  
end
