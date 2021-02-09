class Api::ActionsController < ApplicationController
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

  def api_params
    api_params.permit(
      :x,:y,:z,:x1,:y1,:x2,:y2,:taps,:delay,:speed,:direction,:duration,:back_pos,:height,:force,:new_name,:index,:ip,:port
    ).to_h.values
  end
end