class ShiftsController < ApplicationController

    def create
        set_calendar
        if @calendar.users.owners.include?(current_user) || @calendar.users.managers.include?(current_user)
          @shift = Shift.new(shift_params)
            if @shift.save
                render json: ('Shift created'), status: :ok
            else
                render json: @shift.errors
            end
        else  render json: ('You do not have access to create a shift.'), status: :unauthorized
        end
    end




    private
    
    def set_calendar
        @calendar = Calendar.find(params[:calendar_id])
    end

    def set_shift
        @shift = Shift.find(params[:id])
    end


    def shift_params
        params.permit(:start_time, :end_time, :calendar_id)
    end
end
