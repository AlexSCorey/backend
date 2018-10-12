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
        @user = current_user
        @publishedshifts = @user.shifts.where(published: true)
        if params["start_date"] && params["end_date"]
            start_date = params["start_date"].to_date
            end_date = params["end_date"].to_date
            if @user
                @shifts = Shift.where(start_time: start_date.beginning_of_day .. end_date.end_of_day)
                render "/shifts/index2.json", status: :ok
            else
                render json: ('You do not have access to these shifts'), status: :unauthorized
            end
        else
            render json: ("start_date and end_date are required"), status: :unprocessable_entity
        end
    end


    def create
        set_calendar
        if admin_user
          @shift = Shift.new(
            start_time: Time.zone.parse(params[:start_time]),
            end_time: Time.zone.parse(params[:end_time]),
            calendar_id: params[:calendar_id],
            capacity: params[:capacity],
            published: params[:published]
          )
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
        if params["start_date"] && params["end_date"] && params["target_date"]
           start_date = params["start_date"].to_date
           end_date = params["end_date"].to_date
           target_date = params["target_date"].to_date
           interval = target_date - start_date
           
            if admin_user
                @past_shifts = Shift.where(calendar_id: @calendar.id, start_time:                  start_date.beginning_of_day .. end_date.end_of_day).to_a
                @new_shifts = []
                @past_shifts.each do |past_shift|
                    shift = Shift.new(
                        start_time: past_shift.start_time + interval.days,
                        end_time: past_shift.end_time + interval.days,
                        calendar_id: past_shift.calendar_id,
                        capacity: past_shift.capacity,
                        published: past_shift.published
                    )
                    shift.users = past_shift.users
                    shift.save!
                    @new_shifts.push(shift)
                end
                render "/shifts/copy.json", status: :ok
            else
                render json: ("You do not have access to copy shifts"), status: :unauthorized
            end
        else
            render json: ("Need to provide start_date, end_date, and target_date")
        end
    end

    def update
        set_calendar
        set_shift
        if admin_user
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
        if admin_user
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
        Time.zone = @calendar.time_zone
    end

    def set_shift
        @shift = Shift.find(params[:id])
    end


    def shift_params
        params.permit(:start_time, :end_time, :calendar_id, :capacity, :published)
    end
end
