class InvitationsController < ApplicationController

  def create
    set_calendar
    set_access
    set_user
    if @user
      @new_user = false
      process_invite
    elsif @access == "owner" || @access == "manager"
      @new_user = true
      create_user
      if @user.save
        process_invite
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: '{}', status: :unauthorized
    end
  end

  def complete
    @invitation = current_invitation
    if @invitation
      @user = @invitation.user
      if @user
        if @user.update_attributes(user_params)
          @invitation.destroy
          render "/users/update.json", status: :ok
        else
          render json: @user.errors.messages, status: :unprocessable_entity
        end
      else
        render json: '{}', status: :unprocessable_entity
      end
    else
      render json: '{}', status: :unauthorized
    end
  end

  private

  def set_calendar
    @calendar = Calendar.find(params[:calendar_id])
  end

  def set_user
    @user = User.find_by(email: params[:email])
  end

  def set_role
    @role = Role.new(user_id: @user.id,
      calendar_id: @calendar.id,
      role: params[:role])
  end

  def create_user
    @user = User.new(
      name: "pending",
      email: params[:email],
      password: rand(36**24).to_s(36)
    )
  end

  def set_access
    if owner
      @access = "owner"
    elsif manager
      @access = "manager"
    end
  end

  def process_invite
    set_role
    if @access == "owner"
      if @role.save
        @new_user ? new_notification : existing_notification
      else
        render json: @role.errors, status: :unprocessable_entity
      end
    elsif @access == "manager"
      if @role.role != "owner"
        if @role.save
          @new_user ? new_notification : existing_notification
        else
          render json: @role.errors, status: :unprocessable_entity
        end
      else
        render json: '{}', status: :unauthorized
      end
    else
      render json: '{}', status: :unauthorized
    end
  end

  def new_notification
    @invitation = Invitation.new(user_id: @user.id)
    @invitation.save
    UserMailer.with(user: @user, calendar: @calendar, invitation: @invitation).welcome_email.deliver_now
    render "/invitations/create.json", status: :ok
  end

  def existing_notification
    UserMailer.with(user: @user, calendar: @calendar).added_email.deliver_now
    render "/invitations/create.json", status: :ok
  end

  def current_invitation
    authenticate_with_http_token do |token, options|
      return  Invitation.find_by_api_token(token)
    end
  end

  def user_params
    params.permit(:name, :password, :phone_number)
  end

end
