class UserCalendarAssociationsController < ApplicationController

    def remove
        @user = User.find(params[:user_id])
        @calendar = Calendar.find(params[:calendar_id])
        if      @calendar.owners.include?(current_user)
            if      @calendar.employees.delete(@user)
                    render json: '{}', status: :ok
            end
        elsif   @calendar.managers.include?(current_user)
                @calendar.employees.delete(@user)
                render json: '{}', status: :ok

        else    render json: '{}', status: :unauthorized
        
        end
 
    end

end
