class UsersController < ApplicationController


    def new
        @user = User.new
    end

    def index
        @users = User.all
        render json: @users
    end

    def create
        @user = User.new(user_params)

        if @user.save
            render "/users/create.json", status: :ok
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    def edit
        set_user
        render json: @user
    end

    def update
        set_user
        if current_user.id != @user_id
            render json: @user.errors, status: :unauthorized
        elsif @user.update_attributes(user_params)
            render json: @user, status: :ok
        else
            render json: @user.errors.messages, status: :unprocessable_entity
        end
    end

    def destroy
        set_user
        @user.destroy
    end


    private
    
    def user_params
        params.permit(:name, :email, :password, :phone_number)
    end

    def set_user
        @user = User.find(params[:id])
    end

end
