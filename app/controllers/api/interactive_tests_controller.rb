class Api::InteractiveTestsController < Api::BaseController
  rescue_from VisionError::ServerNotRunning, with: :server_not_found
  rescue_from VisionError::CamNotConnected, with: :cam_not_found
  rescue_from VisionError::CoordinatesNotFound, with: :coordinates_not_found
  rescue_from VisionError::MarkerNotFound, with: :marker_not_found
  rescue_from VisionError::CamNotDetected, with: :cam_not_detected
  rescue_from VisionError::QuacoExecutionError, with: :quaco_execution_failed
  rescue_from VisionError::QuacoDisconnected, with: :quaco_disconnected
  rescue_from VisionError::WrongQuacoInstruction, with: :wrong_quaco_instruction
  def execute_touch
    screen_shot, result = Vision.new.execute_touch(params[:croped_image])
    render json: {screen_shot: screen_shot, result: result}
  end

  def execute_predefined_actions
    render json: {screen_shot: Vision.new.execute_predefined_actions}
  end

  def execute_text_command
    screen_shot, result = Vision.new.execute_text_command(params[:text_command])
    render json: {screen_shot: screen_shot, result: result}
  end

  def capture_screen_shot
    render json: {screen_shot: Vision.new.capture}
  end

  def detect_marker
    screen_shot, result = Vision.new.detect_marker
    render json: {result: result, screen_shot: screen_shot}
  end

  def connect_vision
    Vision.new.connect
    render json: {result: 'Connected'}
  end

  def disconnect_vision
    Vision.new.disconnect
    render json: {result: 'Disconnected'}
  end

  def restart_vision_server
    Vision.new.restart_server
    render json: {result: 'Done'}
  end

  def init
    Vision.new.connect
    Vision.new.detect_marker
    render json: {status: 'Success'}
  end

  def perform
    @action_id = params[:action_id]
    api_params = params.permit(
      :x,:y,:z,:x1,:y1,:x2,:y2,:taps,:delay,:speed,:direction,:duration,:back_pos,:height,:force,:new_name,:index,:ip,:port
    ).to_h 
    @quaco_instruction = QuacoInstructionBuilder.new(@action_id, api_params).build
 
    if @quaco_instruction == 'not_found'
      raise VisionError::WrongQuacoInstruction
    end
    
    @result = Quaco.execute_now(@quaco_instruction)
    if @result == 'disconnected'
      raise VisionError::QuacoDisconnected
    elsif @result != "1\n"
      raise VisionError::QuacoExecutionError
    end
    if params[:capture] == "true" && params[:wait].present?
      sleep(params[:wait].to_i)
    end
    api_result = {api_call: @quaco_instruction, result: "Command Executed Successfully", status: 'Success'}
    if params[:capture] == "true"
      api_result.merge!(screen_shot: Vision.new.capture)
    end
    render json: api_result
  end

  protected

  def quaco_execution_failed
    render json: {api_call: quaco_input(@quaco_instruction), result: quaco_output(@result), status: 'Quaco execution failed'}, status: 422
  end
  def wrong_quaco_instruction
    render json: {api_call: quaco_input(@quaco_instruction), result: "", status: 'Wrong API call'}, status: 422
  end
  def quaco_disconnected
    render json: {api_call: quaco_input(@quaco_instruction), result: "", status: 'Quaco disconnected'}, status: 422
  end
  def server_not_found
    render json: {api_call: quaco_input(@quaco_instruction), result: quaco_output(@result), status: 'Vision server not responding'}, status: 422
  end
  def cam_not_found
    render json: {api_call: quaco_input(@quaco_instruction), result: quaco_output(@result), status: 'Vision cam not connected'}, status: 422
  end
  def coordinates_not_found
    render json: {api_call: quaco_input(@quaco_instruction), result: quaco_output(@result), status: 'Coordinates not found'}, status: 422
  end
  def marker_not_found
    render json: {api_call: quaco_input(@quaco_instruction), result: quaco_output(@result), status: 'Marker not detected'}, status: 422
  end
  def cam_not_detected
    render json: {api_call: quaco_input(@quaco_instruction), result: quaco_output(@result), status: 'Vision Cam not detected'}, status: 422
  end

  def quaco_output(result)
    result.blank? ? '' : "#{OutputSender::O_MAP[result.to_i]}"
  end

  def quaco_input(quaco_instruction)
    quaco_instruction.present? ? quaco_instruction : 'Not generated'
  end
end