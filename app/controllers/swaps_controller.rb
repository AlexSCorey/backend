class SwapsController < ApplicationController

  def create
    set_shift
    @user = current_user
    if @shift.users.include?(@user)
      @swap = Swap.new(requesting_user_id: @user.id,
        shift_id: @shift.id)
      if @swap.save
        render "/swaps/create.json", status: :ok
      else
        render json: @swap.errors, status: :unprocessable_entity
      end
    else
      render json: '{}', status: :unauthorized
    end
  end
  
  def index
    set_calendar
    if @calendar.users.include?(current_user)
      @swaps = @calendar.swaps
      render "/swaps/index.json", status: :ok
    else
      render json: '{}', status: :unauthorized
    end
  end

  def update
    set_swap
    @user = current_user
    if @calendar.users.include?(current_user)
      if !@swap.accepting_user_id
        if @swap.update_attributes(accepting_user_id: @user.id)
          render "/swaps/update.json", status: :ok
        else
          render json: @swap.errors, status: :unprocessable_entity
        end
      else
        render json: {error: "swap already accepted"}, status: :unprocessable_entity
      end
    else
      render json: '{}', status: :unauthorized
    end
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

  def set_swap
    @swap = Swap.find(params[:id])
  end

end
