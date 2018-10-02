class CalendarsController < ApplicationController

  def index
    if current_user
      @owned_calendars = current_user.owned_calendars
      @managed_calendars = current_user.managed_calendars
      @employed_calendars = current_user.employed_calendars
      render "/calendars/index.json", status: :ok
    else
      render json: '{}', status: :unauthorized
    end
  end

  def create
    if current_user
      @calendar = Calendar.new(calendar_params)
      if @calendar.save
        @calendar.owners.push(current_user)
        render json: @calendar, status: :ok
      else
        render json: @calendar.errors, status: :unprocessable_entity
      end
    else
      render json: '{}', status: :unauthorized
    end
  end

  def show
    set_calendar
    if @calendar.owners.include?(current_user) ||
      @calendar.managers.include?(current_user) ||
      @calendar.employees.include?(current_user)
      render json: @calendar, status: :ok
    else
      render json: '{}', status: :unauthorized
    end
  end

  def update
    set_calendar
    if @calendar.owners.include?(current_user) ||
      @calendar.managers.include?(current_user)
      if @calendar.update_attributes(calendar_params)
        render json: @calendar, status: :ok
      else
        render json: @calendar.errors, status: :unprocessable_entity
      end
    else
      render json: '{}', status: :unauthorized
    end
  end

  def destroy
    set_calendar
    if @calendar.owners.include?(current_user)
      if @calendar.destroy
        render json: '{}', status: :ok
      else
        render json: @calendar.errors, status: :unprocessable_entity
      end
    else
      render json: '{}', status: :unauthorized
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
