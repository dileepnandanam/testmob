class TestScenariosController < ApplicationController
  before_action :check_user

  def update
    @test = TestScenario.find(params[:id])
    @test.update test_params
    TestScenarioRunner.perform_later(@test.id, current_user.id, "#result_#{@test.id}")
  end

  protected

  def test_params
    params.require(:test_scenario).permit(:code)
  end


  def check_user
    unless ['platform', 'client'].include? current_user.try(:usertype)
      redirect_to root_path
    end
  end
end