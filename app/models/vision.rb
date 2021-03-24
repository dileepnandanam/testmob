require 'base64'
class Vision
  def execute_touch(image)
    image_header_end_at = 'data:image/jpeg;base64,'.length
    image = image[(image_header_end_at)..-1]

    f=File.open('/tmp/vision_input.jpeg', 'wb')
    f.write(Base64.strict_decode64(image))
    f.close
    image_from_filename `curl --form "p=q" -X POST localhost:8080/execute_touch`
  end
  
  def execute_predefined_actions
    image_from_filename `curl --form "p=q" -X POST localhost:8080/execute_predefined_actions`
  end
  
  def execute_text_command(text)
    image_from_filename `curl --form "text=#{text}" -X POST localhost:8080/execute_text_command`
  end
  
  def capture
    image_from_filename `curl localhost:8080/capture`

  end

  def image_from_filename(filename)
    filename = [filename, '/tmp/vision_output.bmp'].select(&:present?)
    File.open(filename, 'rb') do |img|
      'data:image/bmp;base64,' + Base64.strict_encode64(img.read)
    end
  end
end
