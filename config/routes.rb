Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  resources :logins, only: [:create]

  post 'password/forgot', to: 'password#forgot'
  post 'password/reset', to: 'password#reset'

  resources :calendars, only: [:index, :create, :show, :update, :destroy] do

    resources :swaps, only: [:index, :update]
    resource :availability_process, only: [:create]
    resource :availability_response, only: [:show, :update]
    resource :invitation, only: [:create]
    resources :notes, only: [:index, :create]

    get '/summary', action: :summary, controller: 'calendars'
    get '/alerts_daily', action: :alerts_daily, controller: 'calendars'
    post '/copy', to: 'shifts#copy'
    

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

  resources :users, only: [:create, :edit, :update]
  get '/myschedule', to: 'shifts#myschedule'
end
