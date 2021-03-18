var crop = null

$(document).on('turbolinks:load', () => {
  $(document).on('ajax:success', '.refresh-vision', (e) => {
    $('.vision-screenshot').attr('src', e.detail[0].screen_shot)
    fill_overlay()
  })

  $(document).on('ajax:success', '.execute-predefined', (e) => {
    $('.vision-screenshot').attr('src', e.detail[0].screen_shot)
    fill_overlay()
  })

  $(document).on('ajax:success', '.execute-command', (e) => {
    $('.vision-screenshot').attr('src', e.detail[0].screen_shot)
    fill_overlay()
  })
  
  fill_overlay = () => {
    $('.vision-screenshot-overlay').css('width', $('.vision-screenshot').css('width'))
    $('.vision-screenshot-overlay').css('height', $('.vision-screenshot').css('height'))
  }
  fill_overlay()
  
  crop = (x1,y1,x2,y2) => {
    var height = y2-y1
    var width = x2-x1
    var aspect_ratio = parseFloat(width)/parseFloat(height)
    $('.crop-result')[0].height = parseInt(300/aspect_ratio)
    var corped_image = $('.crop-result')[0]
    var canvas_context = corped_image.getContext("2d")
    var vision_image = $('.vision-screenshot')[0]
    canvas_context.drawImage(vision_image, x1, y1, width, height, 0, 0, 300, 300/aspect_ratio)
  }

  var dragx1 = 0
  var dragy1 = 0
  var dragx2 = 0
  var dragy2 = 0

  reset_drag = () => {
    dragx1 = 0
    dragy1 = 0
    dragx2 = 0
    dragy2 = 0
    $('.vision-selection').css('top', '0px')
    $('.vision-selection').css('left', '0px')
    $('.vision-selection').css('display', 'none')
  }
  $('.vision-screenshot-overlay').mousedown((e) => {
    dragx1 = e.originalEvent.layerX
    dragy1 = e.originalEvent.layerY
    $('.vision-selection').css('display', 'inline')
  })

  $('.vision-screenshot-overlay').mouseup((e) => {
    dragx2 = e.originalEvent.layerX
    dragy2 = e.originalEvent.layerY
    crop(dragx1, dragy1, dragx2, dragx2)
    reset_drag()
  })
  $(".vision-screenshot-overlay").mouseout((e) => {
    reset_drag()
  })
  $(".vision-screenshot-overlay").mousemove( (e) => {
    var dragx = e.originalEvent.layerX
    var dragy = e.originalEvent.layerY
    $('.vision-selection').css('top', dragx1+'px')
    $('.vision-selection').css('left', dragy1+'px')
    $('.vision-selection').css('width', (dragx - dragx1)+'px')
    $('.vision-selection').css('height', (dragx - dragy1)+'px')
  })
})
