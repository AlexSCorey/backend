class UsersController < ApplicationController

    def create
        @user = User.new(user_params)

        if @user.save
            render :json => @user, status: :ok
        else
            render :json => @user.errors
        end
    end



    private
    
    def user_params
        parms.permit(:name, :email, :password, :phone_number)
    end

end
