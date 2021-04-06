class Api::InteractiveTestsController < Api::BaseController
  rescue_from VisionError::ServerNotRunning, with: :server_not_found
  rescue_from VisionError::CamNotConnected, with: :cam_not_found
  rescue_from VisionError::CoordinatesNotFound, with: :coordinates_not_found
  rescue_from VisionError::MarkerNotFound, with: :marker_not_found
  rescue_from VisionError::CamNotDetected, with: :cam_not_detected
  def execute_touch
    screen_shot, result = Vision.new.execute_touch(params[:croped_image])
    render json: {screen_shot: screen_shot, result: result}
  end

  def execute_predefined_actions
    render json: {screen_shot: Vision.new.execute_predefined_actions}
  end

  def execute_text_command
    render json: {screen_shot: Vision.new.execute_text_command(params[:text_command])}
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

  def perform
    action_id = params[:action_id]
    api_params = params.permit(
      :x,:y,:z,:x1,:y1,:x2,:y2,:taps,:delay,:speed,:direction,:duration,:back_pos,:height,:force,:new_name,:index,:ip,:port
    ).to_h 
    quaco_instruction = QuacoInstructionBuilder.new(action_id, api_params).build
    result = Quaco.execute_now(quaco_instruction)
    sleep(2)
    render json: {screen_shot: Vision.new.capture, api_call: quaco_instruction, result: result}
  end

  protected

  
  def server_not_found
    render json: {status: 'Vision server not responding'}, status: 422
  end
  def cam_not_found
    render json: {status: 'Vision cam not connected'}, status: 422
  end
  def coordinates_not_found
    render json: {status: 'Coordinates not found'}, status: 422
  end
  def marker_not_found
    render json: {status: 'Marker not detected'}, status: 422
  end
  def cam_not_detected
    render json: {status: 'Vision Cam not detected'}, status: 422
  end
end