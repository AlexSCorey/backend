class UsersController < ApplicationController


    def new
        @user = User.new
    end

    def index
        @calendar = Calendar.find(params[:calendar_id])
        if @calendar.employees.include?(current_user)
            render "/users/index.json", status: :ok
        elsif @calendar.managers.include?(current_user)
            render "/users/index.json", status: :ok
        elsif @calendar.owners.include?(current_user)
            render "/users/index.json", status: :ok
        else
            render json: ("You don't have access to this calendar"), status: :unauthorized
        end
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
        if current_user.id != @user.id
            render json: @user.errors, status: :unauthorized
        elsif @user.update_attributes(user_params)
            render "/users/update.json", status: :ok
        else
            render json: @user.errors.messages, status: :unprocessable_entity
        end
    end


    private
    
    def user_params
        params.permit(:name, :email, :password, :phone_number)
    end

    def set_user
        @user = User.find(params[:id])
    end

end
