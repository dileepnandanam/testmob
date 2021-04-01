require 'base64'
class Vision
  def execute_touch(image)
    image_header_end_at = 'data:image/jpeg;base64,'.length
    image = image[(image_header_end_at)..-1]

    f=File.open('/tmp/vision_input.jpeg', 'wb')
    f.write(Base64.strict_decode64(image))
    f.close

    coordinates = `curl localhost:8080/get_coordinates_from_image`
    coordinates = coordinates.split(',').map(&:to_i)
    #execute quaco
    capture
  end
  
  def execute_predefined_actions
    #execute quaco
    capture
  end
  
  def execute_text_command(text)
    coordinates = `curl --form "text_command=#{text}" -X POST localhost:8080/get_coordinates_from_command`
    coordinates = coordinates.split(',').map(&:to_i)
    #execute quaco
    capture
  end
  
  def capture
    `curl localhost:8080/capture`
    get_vision_output
  end

  def get_vision_output
    File.open('/tmp/vision_output.jpg', 'rb') do |img|
      'data:image/jpg;base64,' + Base64.strict_encode64(img.read)
    end
  end

  def connect
    unless `curl localhost:8080/connect` == 'ok'
      raise VisionCamNotConnected
    end 
  end

  def detect_marker
    if (result = `curl localhost:8080/detect_marker`) == 'not detected'
      raise MarkerNotFound
    else
      return result
    end
  end

  def disconnect
    unless `curl localhost:8080/disconnect` == 'ok'
      raise VisionCamNotConnected
    end
  end
end
