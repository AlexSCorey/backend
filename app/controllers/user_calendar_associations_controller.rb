class UserCalendarAssociationsController < ApplicationController

    def create
        set_calendar
        set_user
        if @calendar.users.owners.include?(current_user)
            Role.add(@user, @calendar, params[:role])
        elsif @calendar.users.managers.include?(current_user)
        @role = "manager"
        update_calendar
        else
        render json: @role.errors, status: :unauthorized
        end
    end

    def update
    end

    def destroy
    end
        

    private
    def set_user
        @user = User.find(params[:user_id])
    end

    def set_calendar
        @calendar = Calendar.find(params[:calendar_id])
    end

    def set_role
        @role = Role.find(user_id: params[:user_id], calendar_id: params[:calendar_id])
    end

end
