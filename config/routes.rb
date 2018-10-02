Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  resources :calendars, only: [:index, :create, :show, :update, :destroy] do
    resources :users, only: [:index]
  end

  delete '/calendars_employees', to: 'user_calendar_associations#remove'


  resources :users, only: [:create, :edit, :update]

  resources :logins, only: [:create]

  
end
