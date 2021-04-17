class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery  with: :exception
  skip_before_action :verify_authenticity_token, if: -> { controller_name == 'sessions' && action_name == 'create' }
  before_action -> {Rails.logger.debug({ip: request.remote_ip, email: current_user.try(:email)})}
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :location, :company_name, :purpose, :prefered_timing])
  end
end
