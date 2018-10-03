class RolesController < ApplicationController
  def create
    set_calendar
    set_user

    @role = Role.new(user_id: @user.id,
      calendar_id: @calendar.id,
      role: params[:role])

    if @calendar.users.owners.include?(current_user)
      if @role.save
        render "/roles/create.json", status: :ok
      else
        render json: @role.errors, status: :unprocessable_entity
      end
    elsif @calendar.users.managers.include?(current_user)
      if @role.role != "owner"
        if @role.save
          render "/roles/create.json", status: :ok
        else
          render json: @role.errors, status: :unprocessable_entity
        end
      else
        render json: ('You do not have access to this part of the site'), status: :unauthorized
      end
    else
      render json: ('You do not have access to this part of the site'), status: :unauthorized
    end
  end

  def destroy
    set_calendar
    set_user

    @role = Role.find_by(user_id: @user.id,
      calendar_id: @calendar.id,
      role: params[:role])

    if @calendar.users.owners.include?(current_user)
      if @role.destroy
        render json: ('This role has been deleted!'), status: :ok
      else
        render json: @role.errors, status: :unprocessable_entity
      end
    elsif @calendar.users.managers.include?(current_user)
      if @role.role != "owner"
        if @role.destroy
          render json: ('This role has been deleted!'), status: :ok
        else
          render json: @role.errors, status: :unprocessable_entity
        end
      else
        render json: ('You do not have access to this part of the site'), status: :unauthorized
      end
    else
      render json: ('You do not have access to this part of the site'), status: :unauthorized
    end
  end
      

  private
  def set_user
    @user = User.find(params[:user_id])
  end

  def set_calendar
    @calendar = Calendar.find(params[:calendar_id])
  end

  def set_role
    @role = Role.find(user_id: params[:user_id], calendar_id: params[:calendar_id])
  end
  
end
