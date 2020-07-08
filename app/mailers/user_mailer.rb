class UserMailer < ApplicationMailer
  default from: 'quaco.web@gmail.com'
  def inbound_demo_request
    @user = params[:user]
    mail(to: AppConfig.where(name: 'sales_email').first, subject: 'New Demo Request')
  end
end