class TestsController < ApplicationController
  before_action :restrict_access
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token
  
  def submit
    api_function = params[:api_function]
    encoded_api_function = Quaco::API_FUNCTION_MAP[api_function]
    api_params = params[:parameters]

    if api_params.present?
      api_params = api_params.permit(
        :x,:y,:z,:x1,:y1,:x2,:y2,:taps,:delay,:speed,:direction,:duration,:back_pos,:height,:force,:new_name,:index,:ip,:port
      ).to_h.values
    end

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

  def show
    @test = current_user.tests.find(params[:id]) || Test.new
    @initial_template = 'test_induviduals/basic_motion'
  end

  def new
    @test = Test.new
    @initial_template = 'test_induviduals/basic_motion'
    render 'show'
  end

  def index
    @tests = current_user.tests
  end

  def create
    @test = current_user.tests.create test_params
    TestRunner.perform_later(@test.id, '.result-inner')
    render plain: 'started'
  end

  def update
    @test = current_user.tests.find(params[:id])
    @test.update test_parredirect_toams
    TestRunner.perform_later(@test.id, '.result-inner')
  end

  def configure
     redirect_to root_path unless current_user.usertype == 'platform'
  end

  def destroy
    Test.find(params[:id]).delete
    redirect_to tests_path
  end

  protected

  def test_params
    params.require(:test).permit(:code, :spec)
  end

  def restrict_access
    if ['pending', 'finished'].include? current_user.usertype
      redirect_to root_path and return
    end
  end
end