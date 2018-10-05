class SwapsController < ApplicationController

  def create
    set_shift
    @user = current_user
    if @shift.users.include?(@user)
      @swap = Swap.new(requesting_user_id: @user.id,
        shift_id: @shift.id)
      if @swap.save
        render json: @swap, status: :ok
      else
        render json: @swap.errors, status: :unprocessable_entity
      end
    else
      render json: '{}', status: :unauthorized
    end
  end
  
  def index
  end

  def update
  end

  def complete
  end

  private

  def set_calendar
    @calendar = Calendar.find(params[:calendar_id])
  end

  def set_shift
    @shift = Shift.find(params[:shift_id])
  end

end
