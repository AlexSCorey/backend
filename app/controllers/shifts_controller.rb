class ShiftsController < ApplicationController


    def index
        set_calendar
        @user = current_user
        @roles = @user.roles.where(calendar_id: @calendar.id).map{|r| r.role}
        if params["start_date"] && params["end_date"]
            start_date = params["start_date"].to_date
            end_date = params["end_date"].to_date
            if @calendar.users.include?(@user)
                @shifts = Shift.where(
                    calendar_id: @calendar.id,
                    start_time: start_date.beginning_of_day .. end_date.end_of_day)
                render "/shifts/index.json", status: :ok
            else
                render json: '{}', status: :unauthorized
            end
        else
            render json: {'error': 'start_date and end_date are required'}, status: :unprocessable_entity
        end
    end

    def myschedule
        @user = User.find(params[:user_id])
        @publishedshifts = @user.shifts.where(published: true)
        if @user
            render "/shifts/index2.json", status: :ok
        else
            render json: ('You do not have access to these shifts'), status: :unauthorized
        end
    end


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

    def copy
        set_calendar
        @past_shift = Shift.find(params[:id])
        if @calendar.users.owners.include?(current_user) || @calendar.users.managers.include?(current_user)
          @shift = @past_shift.dup
          @shift.users = @past_shift.users
          if @shift.save
            render json: ("Shift copied successfully"), status: :ok
          else
            render json: @usershift.errors, status: :uprocessable_entity
          end
        else
          render json: ("You do not have access to copy shifts"), status: :unauthorized
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
