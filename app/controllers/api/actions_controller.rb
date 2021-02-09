class Api::ActionsController < ApplicationController
  before_action :authenticate!

  def perform
    api_function = params[:action_id]
    encoded_api_function = Quaco::API_FUNCTION_MAP[api_function]
    api_params = params[:parameters]

    api_params = params.permit(
      :x,:y,:z,:x1,:y1,:x2,:y2,:taps,:delay,:speed,:direction,:duration,:back_pos,:height,:force,:new_name,:index,:ip,:port
    ).to_h.values

    if api_params.present?
      encoded_api_call = encoded_api_function +
                         api_params.join(':') +
                         ':'
    else
      encoded_api_call = encoded_api_function
    end

    result = Quaco.execute_now(encoded_api_call)

    render json: {
      api_call: encoded_api_call,
      result: result
    }
  end

  protected

  def authenticate!
    access_token = params[:access_token] || request.headers['access_token']
    email = params[:email] || request.headers['email']
    user = User.where(access_token: access_token, email: email).first

    unless user.present? && ['client', 'platform'].include?(user.usertype) && user.access_token.present?
      render json: {message: 'Access denied'}, status: 401 and return
    end
  end
end