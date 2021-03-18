class InteractiveTestsController < ApplicationController
  before_action :check_user

  def index
    
  end

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

  protected

  def check_user
    unless ['platform', 'client'].include? current_user.try(:usertype)
      redirect_to root_path
    end
  end
end