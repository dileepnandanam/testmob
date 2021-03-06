class Api::ActionsController < Api::BaseController
  before_action :respond_to_sandbox_mode

  def perform
    quaco_api_call = encoded_api_call

    result = Quaco.execute_now(quaco_api_call)

    render json: {
      api_call: quaco_api_call,
      result: result
    }
  end

  protected

  def respond_to_sandbox_mode
    if params[:sandbox_mode].present? || request.headers[:sandbox_mode].present?
      render json: {
        api_call: encoded_api_call,
        result: '1/n'
      } and return
    end
  end

  def encoded_api_call
    api_function = params[:action_id]
    encoded_api_function = Quaco::API_FUNCTION_MAP[api_function]

    api_params = params.permit(
      :x,:y,:z,:x1,:y1,:x2,:y2,:taps,:delay,:speed,:direction,:duration,:back_pos,:height,:force,:new_name,:index,:ip,:port
    ).to_h.values

    if api_params.present?
      return encoded_api_function +
                         api_params.join(':') +
                         ':'
    else
      return encoded_api_function
    end
  end
end