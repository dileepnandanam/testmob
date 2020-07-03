class UserMailer < ApplicationMailer
  default from: 'quaco.web@gmail.com'
  def inbound_demo_request
    @user = params[:user]
    mail(to: 'support@sastrarobotics.com', subject: 'New Demo Request')
  end
end