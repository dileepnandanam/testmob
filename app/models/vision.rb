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
    coordinates = `curl --form "text_command#{text}" -X POST localhost:8080/get_coordinates_from_command`
    coordinates = coordinates.split(',').map(&:to_i)
    #execute quaco
    capture
  end
  
  def capture
    `curl localhost:8080/capture`
    get_vision_output
  end

  def get_vision_output
    File.open('/tmp/vision_output.bmp', 'rb') do |img|
      'data:image/bmp;base64,' + Base64.strict_encode64(img.read)
    end
  end
end
