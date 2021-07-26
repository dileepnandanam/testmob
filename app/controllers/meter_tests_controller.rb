class MeterTestsController < ApplicationController
  def index
    @energy_meter_test = TestScenario.for('energy_meter')
    @gas_meter_test = TestScenario.for('gas_meter')
    @ppmid_test = TestScenario.for('ppmid')
    @meter_test = @energy_meter_test
  end

  def show
    @meter_test = TestScenario.find(params[:id])
  end

  def run
    MeterTestRunner.perform_later(params[:id], current_user.id, '.meter-test-result')
  end

  def update
    @test = TestScenario.find(params[:id])
    @test.update(params.require(:test_scenario).permit(:code))
  end

  def get_ocr_result
    @ocr_result = Vision.new.get_ocr_result(params[:target])
    @image = Vision.new.get_vision_output
  end
end