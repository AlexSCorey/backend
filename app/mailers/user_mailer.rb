class UserMailer < ApplicationMailer
  default from: 'GregorySDTaylor+shiftwerk@gmail.com'

  def welcome_email
    welcome_page = "https://scheduler-79e4e.firebaseapp.com/welcome/"
    @user = params[:user]
    @calendar = params[:calendar]
    @invitation = params[:invitation]
    @url  = welcome_page + params[:invitation].api_token
    mail(to: @user.email, subject: 'Welcome to shiftwerk!')
  end

  def added_email
    @user = params[:user]
    @calendar = params[:calendar]
    @url = "https://scheduler-79e4e.firebaseapp.com/login"
    mail(to: @user.email, subject: "You've been added to a new calendar on shiftwerk!")
  end

  def forgot_password
    pw_reset = "https://schedule-79e4e.firebaseapp.com/password/reset/"
    @user = params[:user]
    @url = pw_reset + params[:user].reset_password_token
    mail(to: @user.email, subject: "Password Reset Instructions")
  end
  
  def swap_complete_email
    complete_page = "https://scheduler-79e4e.firebaseapp.com/complete/"
    @swap = params[:swap]
    @managers = params[:swap].shift.calendar.users.managers
    @url = complete_page + params[:swap].api_token
    mail(to: @managers.map{|m| m.email}, subject: "shift swap pending approval")
  end

  def swap_decision_email
    @swap = params[:swap]
    @accepting_user = params[:accepting_user]
    @decision = params[:decision]
    mail(to: [@accepting_user.email, @swap.requesting_user.email],
      subject: "shift swap " + @decision)
  end

  def availability_request_email
    response_page = "https://scheduler-79e4e.firebaseapp.com/availability_response/"
    @request = params[:request]
    @url  = response_page + @request.api_token
    dates = (@request.availability_process.start_date.to_date.to_s + " through " +
      @request.availability_process.end_date.to_date.to_s)
    mail(to: @request.user.email,
      subject: "shiftgear availability requested for " + dates)
  end

end
