require 'base64'
class Vision
  def execute_touch(image)
    image_header_end_at = 'data:image/jpeg;base64,'.length
    image = image[(image_header_end_at)..-1]

    f=File.open('/tmp/vision_input.jpeg', 'wb')
    f.write(Base64.strict_decode64(image))
    f.close

    result = `curl localhost:8080/get_coordinates_from_image`
    raise_error_for(result)
    #execute quaco
    capture
  end
  
  def execute_predefined_actions
    #execute quaco
    capture
  end
  
  def execute_text_command(text)
    result = `curl --form "text_command=#{text}" -X POST localhost:8080/get_coordinates_from_command`
    raise_error_for(result)
    #execute quaco
    capture
  end
  
  def capture
    result = `curl localhost:8080/capture`
    raise_error_for(result)
    get_vision_output
  end

  def connect
    result = `curl localhost:8080/connect`
    raise_error_for(result)
    result
  end

  def detect_marker
    result = `curl localhost:8080/detect_marker`
    raise_error_for(result)
    result
  end

  def disconnect
    result = `curl localhost:8080/disconnect` == 'ok'
    raise_error_for(result)
  end

  def get_vision_output
    File.open('/tmp/vision_output.jpg', 'rb') do |img|
      'data:image/jpg;base64,' + Base64.strict_encode64(img.read)
    end
  end

  def raise_error_for(result)
    if result == 'coordinates_not_found'
      raise VisionError::CoordinatesNotFound
    elsif result == 'marker_not_found'
      raise VisionError::MarkerNotFound
    elsif result == 'cam_not_conneted'
      raise VisionError::CamNotConnected
    elsif result == 'cam_not_detected'
      raise VisionError::CamNotDetected
    elsif result == ''
      raise VisionError::ServerNotRunning
    end
  end
end
