class UsershiftsController < ApplicationController
  
  
  def create
    set_calendar
    if admin_user
      @usershift = Usershift.new(usershift_params)
      if @usershift.save
        render json: ('Employee added to shift.'), status: :ok
      else
        render json: @usershift.errors
      end
    else  render json: ('You do not have access to assign shifts'), status: :unauthorized
    end
  end


  def destroy
    set_calendar
    @usershift = Usershift.find(params[:id])
    if admin_user
      if @usershift.destroy
        render json: ("Empoyee shift deleted!"), status: :ok
      else
          render json: @usershift.errors, status: :uprocessable_entity
      end
    else  render json: ("You don't have access to delete employee shifts.")
    end
  end


  private

  def set_calendar
    @calendar = Calendar.find(params[:calendar_id])
  end

  def usershift_params
    params.permit(:user_id, :shift_id)
  end
end
