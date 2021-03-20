require 'base64'
class Vision
  def execute_touch(image)
    image_header_end_at = 'data:image/jpeg;base64,'.length
    image = image[(image_header_end_at)..-1]
    return `curl --form "croped_image=#{image}" -X POST localhost:8080/execute_touch`
  end
  
  def execute_predefined_actions
    return `curl --form "p=q" -X POST localhost:8080/execute_predefined_actions`
  end
  
  def execute_text_command(text)
    return `curl --form "text=#{text}" -X POST localhost:8080/execute_text_command`
  end
  
  def capture
    #Uncomment this for development
    #File.open(Rails.root.join('vis.bmp'), 'rb') do |img|
    #  'data:image/bmp;base64,' + Base64.strict_encode64(img.read)
    #end
    return `curl localhost:8080/capture`
  end
end
