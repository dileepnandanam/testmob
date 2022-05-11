class Api::MeterTestsController < Api::BaseController
  def execute
    lines = params[:commands].split("##")
    results = []
    lines.each do |line|
      if Quaco.closed?
        results << "disconnected"
        break
      end
      if line.starts_with?('delay')
        sleep(line.split(':').last.to_f)
        results << "waiting"
      elsif
        line.starts_with?('comment')
        result << line.split(':').last
      else
        result = Quaco.execute(user_id, line, 'invalid_target') if line.present?
        results << "executed #{line} result: #{result}"
      end
    end

    ocr_results = Vision.new.get_ocr_result(params[:target])
    render json: {ocr_results: ocr_results, results: results, screen_shot: Vision.new.get_vision_output}
  end
end
