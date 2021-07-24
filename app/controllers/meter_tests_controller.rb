class MeterTestsController < ApplicationController
  def index
    @energy_meter_test = TestScenario.for('energy_meter')
    @gas_meter_test = TestScenario.for('gas_meter')
    @ppmid_test = TestScenario.for('ppmid')
  end

  def show
    @test = TestScenario.find(params[:id])
  end

  def run
    MeterTestRunner.perform_later(params[:id])
  end

  def update
    @test = TestScenario.find(params[:id])
    @test.update(params.require(:test_scenario).permit(:code))
  end
end