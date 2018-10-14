Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  resources :logins, only: [:create]

  post 'password/forgot', to: 'password#forgot'
  post 'password/reset', to: 'password#reset'
  post 'invitations/complete', to: 'invitations#complete'

  resources :calendars, only: [:index, :create, :show, :update, :destroy] do

    resources :swaps, only: [:index, :update]
    resource :availability_response, only: [:show, :update]
    resource :invitation, only: [:create]
    resources :notes, only: [:index, :create]

    get '/summary', action: :summary, controller: 'calendars'
    get '/alerts_daily', action: :alerts_daily, controller: 'calendars'
    get '/alerts_weekly', action: :alerts_weekly, controller: 'calendars'
    post '/copy', to: 'shifts#copy'
    
    resources :availability_processes, only: [:create] do
      post '/assign_shifts', action: :assign_shifts, controller: 'availability_processes'
    end

    resources :shifts, only: [:index, :create, :update, :destroy] do
      resources :swaps, only: [:create]
      resources :usershifts, only: [:create, :destroy,]
      get '/users', action: :shift_users_index, controller: 'users'
    end

    resources :users, only: [:index] do
      resource :role, only: [:create, :destroy]
      resources :shifts, only: [:index]
    end
  end
  patch '/update', to: 'users#update'
  resources :users, only: [:create]
  get '/myschedule', to: 'shifts#myschedule'
end
