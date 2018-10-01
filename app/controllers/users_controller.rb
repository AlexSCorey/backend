class UsersController < ApplicationController

    def create
        @user = User.new(user_params)

        if @user.save
            render "/users/create.json", status: :ok
        else
            render json: @user.errors, status: :unprocessable_entity
        end

    end



    private
    
    def user_params
        params.permit(:name, :email, :password, :phone_number)
    end

end
