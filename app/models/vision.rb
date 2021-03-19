require 'base64'
class Vision
  def execute_touch(image)
    return(image)
  end
  
  def execute_predefined_actions
    return(capture)
  end
  
  def execute_text_command(text)
    return(capture)
  end
  
  def capture
    File.open(Rails.root.join('vis.bmp'), 'rb') do |img|
      'data:image/bmp;base64,' + Base64.strict_encode64(img.read)
    end
  end
end
