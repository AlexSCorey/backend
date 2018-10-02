class CalendarsController < ApplicationController

  def index
    if current_user
      @owned_calendars = current_user.owned_calendars
      @managed_calendars = current_user.managed_calendars
      @employed_calendars = current_user.employed_calendars
      render "/calendars/index.json", status: :ok
    else
      render :json => "unauthorized", status: :unauthorized
    end
  end

  def create
    if current_user
      @calendar = Calendar.new(calendar_params)
      if @calendar.save
        @calendar.owners.push(current_user)
        render :json => @calendar, status: :ok
      else
        render :json => @calendar.errors, status: :unprocessable_entity
      end
    else
      render :json => "unauthorized", status: :unauthorized
    end
  end

  def show
    if current_user
    else
      render :json => "unauthorized", status: :unauthorized
    end
  end

  def update
    if current_user
    else
      render :json => "unauthorized", status: :unauthorized
    end
  end

  def destroy
    if current_user
    else
      render :json => "unauthorized", status: :unauthorized
    end
  end

  private
    
    def calendar_params
        params.permit(:name,
          :employee_hour_threshold_daily,
          :employee_hour_threshold_weekly,
          :time_zone,
          :daylight_savings)
    end

    def set_calendar
        @calendar = Calendar.find(params[:id])
    end

end
