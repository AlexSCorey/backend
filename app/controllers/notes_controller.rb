class NotesController < ApplicationController

  def index
    set_user
    set_calendar

    if params["start_date"] && params["end_date"]
      if @calendar.users.owners.include?(@user) ||
        @calendar.users.managers.include?(@user)
        @notes = Note.where(calendar_id: @calendar.id,
          date: params["start_date"]..params["end_date"])
        render "/notes/index.json", status: :ok
      elsif @calendar.users.employees.include?(@user)
        @notes = Note.where(calendar_id: @calendar.id,
          user_id: @user.id,
          date: params["start_date"]..params["end_date"])
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
        user_id: @user.id}.merge(note_params))
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
  end

  def note_params
    params.permit(:text, :date)
  end

end
