class OutputSender < ApplicationJob
  O_MAP = {
    1 => "Command Executed Successfully",
    0 => "Command Failed",
    -2 => "Emergency Stop pressed / Door open / Torque off",
    -4 => "Invalid Parameters",
    -5 => "Invalid API",
    -6 => "Outside Workspace",
    -7 => "Invalid Path",
    -8 => "Manipulator is not Homed",
    -9 => "Wrong number of parameters",
    -10 => "Parameter data type is wrong"
  }
  def perform(user_id, line, output)
    if AppConfig.where(name: 'target_quaco').first.value == 'quaco_2'
      output_code = output
    else
      output_code = output.encode("UTF-8", invalid: :replace).strip.to_i
    end
    
    @user = User.find(user_id)
    ApplicationCable::NotificationsChannel.broadcast_to(
      @user,
      message: "<div class='result-line'>#{line}<br/>#{output_code}</div>"
      #message: output
    )
  end
end