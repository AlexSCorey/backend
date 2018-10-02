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
        @role = "owner"
        render "/calendars/show.json", status: :ok
      else
        render json: @calendar.errors, status: :unprocessable_entity
      end
    else
      render json: '{}', status: :unauthorized
    end
  end

  def show
    set_calendar
    if @calendar.owners.include?(current_user)
      @role = "owner"
      render "/calendars/show.json", status: :ok
    elsif @calendar.managers.include?(current_user)
      @role = "manager"
      render "/calendars/show.json", status: :ok
    elsif @calendar.employees.include?(current_user)
      @role = "employee"
      render "/calendars/show.json", status: :ok
    else
      render json: '{}', status: :unauthorized
    end
  end

  def update
    set_calendar
    if @calendar.owners.include?(current_user)
      @role = "owner"
      update_calendar
    elsif @calendar.managers.include?(current_user)
      @role = "manager"
      update_calendar
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

    def update_calendar
      if @calendar.update_attributes(calendar_params)
        render "/calendars/show.json", status: :ok
      else
        render json: @calendar.errors, status: :unprocessable_entity
      end
    end

end
