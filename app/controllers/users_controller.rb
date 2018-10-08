class UsersController < ApplicationController


    def new
        @user = User.new
    end

    def index
        @calendar = Calendar.find(params[:calendar_id])
        if @calendar.users.include?(current_user)
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

    def update
        @user = User.find(params[:id])
        if current_user.id != @user.id
            render json: @user.errors, status: :unauthorized
        elsif @user.update_attributes(user_params)
            render "/users/update.json", status: :ok
        else
            render json: @user.errors.messages, status: :unprocessable_entity
        end
    end

    def shift_users_index
        @calendar = Calendar.find(params[:calendar_id])
        @shift = Shift.find(params[:shift_id])
        if @calendar.users.include?(current_user)
            @assigned_users = @shift.users
            @unassigned_users = @calendar.users -= @assigned_users
            render "/users/shift_users_index.json", status: :ok
        else
            render json: nil, status: :unauthorized
        end
    end


    private
    
    def user_params
        params.permit(:name, :email, :password, :phone_number)
    end

end
