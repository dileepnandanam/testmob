class Api::BaseController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :check_user!
  protected

  def check_user!
    user = current_user_from_token_or_session
    unless user && ['client', 'platform'].include?(user.usertype)
      render json: {message: 'Access denied'}, status: 401 and return
    end
  end

  def current_user_from_token_or_session
    access_token = params[:access_token] || request.headers['access-token']
    email = params[:email] || request.headers['email']
    user = User.where(access_token: Digest::SHA1.hexdigest(access_token.to_s), email: email).first
    user || current_user
  end
end