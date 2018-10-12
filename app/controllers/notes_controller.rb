class NotesController < ApplicationController

  def index
    set_user
    set_calendar

    if params["start_date"] && params["end_date"]
      if @calendar.users.owners.include?(@user) ||
        @calendar.users.managers.include?(@user)
        start_date = Time.zone.parse(params["start_date"])
        end_date = Time.zone.parse(params["end_date"])
        @notes = Note.where(calendar_id: @calendar.id,
          date: start_date..end_date)
        render "/notes/index.json", status: :ok
      elsif @calendar.users.employees.include?(@user)
        @notes = Note.where(calendar_id: @calendar.id,
          user_id: @user.id,
          date: start_date..end_date)
          render "/notes/index.json", status: :ok
      else
        render json: '{}', status: :unauthorized
      end
    else
      render json: {'error': 'start date and end date are required'}, status: :unprocessable_entity
    end
  end
  
  def create
    set_user
    set_calendar
    if @calendar.users.include?(@user)
      @note = Note.new({calendar_id: @calendar.id,
        user_id: @user.id,
        text: params[:text],
        date: Time.zone.parse(params[:date])
      })
      if @note.save
        render json: @note, status: :ok
      else
        render json: @note.errors, status: :unprocessable_entity
      end
    else
      render json: '{}', status: :unauthorized
    end
  end

  private

  def set_user
    @user = current_user
  end

  def set_calendar
    @calendar = Calendar.find(params[:calendar_id])
    Time.zone = @calendar.time_zone
  end

  def note_params
    params.permit(:text, :date)
  end

end
