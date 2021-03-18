var crop = null

$(document).on('turbolinks:load', () => {
  $(document).on('ajax:success', '.refresh-vision', (e) => {
    $('.vision-screenshot').attr('src', e.detail[0].screen_shot)
  })

  $(document).on('ajax:success', '.execute-predefined', (e) => {
    $('.vision-screenshot').attr('src', e.detail[0].screen_shot)
  })

  $(document).on('ajax:success', '.execute-command', (e) => {
    $('.vision-screenshot').attr('src', e.detail[0].screen_shot)
  })

  
  crop = (x1,y1,x2,y2) => {
    var height = y2-y1
    var width = x2-x1
    var aspect_ratio = parseFloat(width)/parseFloat(height)
    $('.crop-result').css('height', 300/aspect_ratio+'px')
    var corped_image = $('.crop-result')[0]
    var canvas_context = corped_image.getContext("2d")
    var vision_image = $('.vision-screenshot')[0]
    canvas_context.drawImage(vision_image, x1, y1, width, height, 0, 0, 300, 300/aspect_ratio)
  }
})
