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

end
