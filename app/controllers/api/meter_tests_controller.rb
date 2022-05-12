class Api::MeterTestsController < Api::BaseController
  def connect_bluetooth
    results = execute TestScenario.for('energy_meter').code
    ocr_results = Vision.new.get_ocr_result(params[:target])
    render json: {ocr_results: ocr_results, screen_shot: Vision.new.get_vision_output}
  end

  def multimedia_play
    results = execute TestScenario.for('gas_meter').code
    ocr_results = Vision.new.get_ocr_result(params[:target])
    render json: {ocr_results: ocr_results, screen_shot: Vision.new.get_vision_output}
  end

  def search_navigation
    results = execute TestScenario.for('ppmid').code
    ocr_results = Vision.new.get_ocr_result(params[:target])
    render json: {ocr_results: ocr_results, screen_shot: Vision.new.get_vision_output}
  end

  def disconnect_bluetooth
    results = execute TestScenario.for('disconnect').code
    ocr_results = Vision.new.get_ocr_result(params[:target])
    render json: {ocr_results: ocr_results, screen_shot: Vision.new.get_vision_output}
  end

  protected

  def execute(commands)
    lines = commands.split(/\n/)
    results = []
    lines.each do |line|
      if Quaco.closed?
        results << "disconnected"
        break
      end
      if line.starts_with?('delay')
        sleep(line.split(':').last.to_f)
        results << "waiting"
      elsif line.starts_with?('comment')
        results << line.split(':').last
      else
        result = Quaco.execute(current_user.id, line, 'invalid_target') if line.present?
        results << "executed #{line} result: #{result}"
      end
    end

    return results
  end
end
