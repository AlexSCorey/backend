class UserCalendarAssociationsController < ApplicationController

    def remove
       set_user
       set_calendar
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

    def delete_manager
        set_user
        set_calendar
        if  @calendar.owners.include?(current_user)
            @calendar.managers.delete(@user)
            render json: '{}', status: :ok
        
        else render json: '{}', status: :unauthorized
        end
    end
        

        private
        def set_user
            @user = User.find(params[:user_id])
        end

        def set_calendar
            @calendar = Calendar.find(params[:calendar_id])
        end

end
