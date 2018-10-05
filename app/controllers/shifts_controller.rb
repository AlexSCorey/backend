class ShiftsController < ApplicationController

    def create
        set_calendar
        if @calendar.users.owners.include?(current_user) || @calendar.users.managers.include?(current_user)
          @shift = Shift.new(shift_params)
            if @shift.save
                render "/shifts/create.json", status: :ok
            else
                render json: @shift.errors
            end
        else  render json: ('You do not have access to create a shift.'), status: :unauthorized
        end
    end

    def update
        set_calendar
        set_shift
        if @calendar.users.owners.include?(current_user) || @calendar.users.managers.include?(current_user)
           if @shift.update_attributes(shift_params)
              render "/shifts/update.json", status: :ok
           else
              render json: @shift.errors, status: :uprocessable_entity
           end
        else  render json: ("You don't have access to update shifts."), status: :unauthorized
        end
    end

    def destroy
        set_calendar
        set_shift
        if @calendar.users.owners.include?(current_user) || @calendar.users.managers.include?(current_user)
            if @shift.destroy
                render json: ("Shift deleted!"), status: :ok
            else
                render json: @shift.errors, status: :uprocessable_entity
            end
        else  render json: ("You don't have access to delete shifts.")
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
        params.permit(:start_time, :end_time, :calendar_id, :capacity, :published)
    end
end
