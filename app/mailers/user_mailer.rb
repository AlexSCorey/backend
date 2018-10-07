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

  def swap_complete_email
    complete_page = "https://scheduler-79e4e.firebaseapp.com/complete/"
    @swap = params[:swap]
    @managers = params[:swap].shift.calendar.users.managers
    @url = complete_page + params[:swap].api_token
    mail(to: @managers.map{|m| m.email}, subject: "shift swap pending approval")
  end

  def swap_notification_email
    @swap = params[:swap]
    @accepting_user = params[:accepting_user]
    @decision = params[:decision]
    mail(to: [@swap.accepting_user.email, @swap.requesting_user.email]}, subject: "shift swap denied")
  end

end
