class NotesController < ApplicationController

  def index
    set_user
    set_calendar
    if @calendar.users.owners.include?(@user) ||
      @calendar.users.managers.include?(@user)
      @notes = Note.where(calendar_id: @calendar.id,
        user_id: @user.id)
      render "/notes/index.json", status: :ok
    else
      render json: '{}', status: :unauthorized
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
  
  def show
  end
  
  def update
  end
  
  def destroy
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
