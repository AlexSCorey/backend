class CalendarsController < ApplicationController

  def index
    if current_user
      @owned_calendars = current_user.calendars.owned
      @managed_calendars = current_user.calendars.managed
      @employed_calendars = current_user.calendars.employed
      render "/calendars/index.json", status: :ok
    else
      render json: ("You do not have access to this part of the site") , status: :unauthorized
    end
  end

  def summary
    @user = current_user
    @calendar = Calendar.find(params[:calendar_id])

    if params["start_date"] && params["end_date"]
      if @calendar.users.include?(@user)
        render json: @calendar.sql_summary_query(params["start_date"], params["end_date"])
      else
        render json: '{}', status: :unauthorized
      end
    else
      render json: {'error': 'start date and end date are required'}, status: :unprocessable_entity
    end
  end


  def create
    if current_user
      @calendar = Calendar.new(calendar_params)
      if @calendar.save
        Role.add(current_user, @calendar, "owner")
        @role = "owner"
        render "/calendars/show.json", status: :ok
      else
        render json: @calendar.errors, status: :unprocessable_entity
      end
    else
      render json: ('You do not have access to this part of the site'), status: :unauthorized
    end
  end

  def show
    set_calendar
    if @calendar.users.owners.include?(current_user)
      @role = "owner"
      render "/calendars/show.json", status: :ok
    elsif @calendar.users.managers.include?(current_user)
      @role = "manager"
      render "/calendars/show.json", status: :ok
    elsif @calendar.users.employees.include?(current_user)
      @role = "employee"
      render "/calendars/show.json", status: :ok
    else
      render json: ('You do not have access to this part of the site!'), status: :unauthorized
    end
  end

  def update
    set_calendar
    if @calendar.users.owners.include?(current_user)
      @role = "owner"
      update_calendar
    elsif @calendar.users.managers.include?(current_user)
      @role = "manager"
      update_calendar
    else
      render json: ('You do not have access to this part of the site'), status: :unauthorized
    end
  end

  def destroy
    set_calendar
    if @calendar.users.owners.include?(current_user)
      if @calendar.destroy
        render json: ('Calendar deleted!'), status: :ok
      else
        render json: @calendar.errors, status: :unprocessable_entity
      end
    else
      render json: ('You do not have access to this part of the site'), status: :unauthorized
    end
  end

  def invite
    set_calendar
    if @calendar.users.owners.include?(current_user)
      # invite using email
    elsif @calendar.users.managers.include?(current_user)
      # invite using email, exclude owner role
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
