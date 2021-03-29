class Api::InteractiveTestsController < ApplicationController
  def execute_touch
    render json: {screen_shot: Vision.new.execute_touch(params[:croped_image])}
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
end