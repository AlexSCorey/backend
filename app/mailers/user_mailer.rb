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
    @user = params[:user]
    @url = "https://schedule-79e4e.firebaseapp.com/password/reset"
    mail(to: @user.email, subject: "Password Reset Instructions")
  end

end
