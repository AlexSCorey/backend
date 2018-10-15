class LoginsController < ApplicationController
  
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      render json: { name: user.name, token: user.api_token }
    else
      render json: nil, status: :unprocessable_entity
    end
  end
end
