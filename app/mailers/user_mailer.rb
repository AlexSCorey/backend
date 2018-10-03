class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'
 
  def test_email
    @user = params[:user]
    @url  = 'https://scheduler-79e4e.firebaseapp.com/login'
    mail(to: @user.email, subject: 'Test for Scheduling Site')
  end

end
