var crop = null

$(document).on('turbolinks:load', () => {
  $(document).on('ajax:success', '.refresh-vision', (e) => {
    $('.vision-screenshot').attr('src', e.detail[0].screen_shot)
    set_loading(false)
    fill_overlay()
  })

  $(document).on('ajax:success', '.detect-marker', (e) => {
    $('.marker-data').html(e.detail[0].result)
    $('.vision-screenshot').attr('src', e.detail[0].screen_shot)
    set_loading(false)
  })

  $(document).on('ajax:success', '.restart-vision-server', (e) => {
    $('.vision-server-data').html(e.detail[0].result)
    set_loading(false)
    setTimeout(() => {$('.vision-server-data').html('')}, 3000)
  })

  $(document).on('ajax:success', '.connect-vision, .disconnect-vision', (e) => {
    $('.vision-data').html(e.detail[0].result)
    set_loading(false)
  })

  $(document).on('ajax:success', '.execute-predefined', (e) => {
    $('.vision-screenshot').attr('src', e.detail[0].screen_shot)
    set_loading(false)
    fill_overlay()
  })

  $(document).on('ajax:success', '.execute-command', (e) => {
    $('.vision-screenshot').attr('src', e.detail[0].screen_shot)
    set_loading(false)
    fill_overlay()
  })

  $(document).on("ajax:before", ".execute-touch", function() {
    var form = $(this)
    form.append($('<input />',{name: 'croped_image',value: $('canvas')[0].toDataURL("image/jpeg")}))
    $(form).find('input[name="croped_image"]').hide()
  })

  $(document).on('ajax:success', '.execute-touch, .touch-point', (e) => {
    $('.vision-screenshot').attr('src', e.detail[0].screen_shot)
    set_loading(false)
  })
  $(document).on('ajax:error', '.refresh-vision, .detect-marker, .execute-predefined, .execute-command, .execute-touch, .touch-point, .connect-vision, .disconnect-vision', (e) => {
    $('.message').html(`<div class="exception d-inline-block">${e.detail[0].status}</div>`)
    set_loading(false)
    setTimeout(()=> {$('.message').html('')}, 3000)
  })
  $('.restart-vision-server, .detect-marker, .refresh-vision, .execute-predefined, .execute-command, input[type="submit"]').on('click', () => {
    set_loading(true)
  })
  step = 100
  $('.zoom-in').click((e) => {
    let init_width = parseInt($('.vision-screenshot').css('width'))
    $('.vision-screenshot').css('width', (init_width + step) + 'px')
    set_overlay_dimensions()
  })
  $('.zoom-out').click((e) => {
    let init_width = parseInt($('.vision-screenshot').css('width'))
    $('.vision-screenshot').css('width', (init_width - step) + 'px')
    set_overlay_dimensions()
  })
  set_loading = (isLoading) => {
    //$('.vision-screenshot').attr('src', $('.loading').data('url'))
    $('.loading').css('display', isLoading ? 'block' : 'none')
  }
  set_overlay_dimensions = () => {
    $('.vision-screenshot-overlay').css('width', $('.vision-screenshot').css('width'))
    $('.vision-screenshot-overlay').css('height', $('.vision-screenshot').css('height'))
  }
  fill_overlay = () => {
    $('.vision-screenshot').one('load', () => {
      set_overlay_dimensions()
    })
  }

  fill_overlay()

  crop = (x1,y1,x2,y2) => {
    var height = y2-y1
    var width = x2-x1
    var aspect_ratio = parseFloat(width)/parseFloat(height)
    $('.crop-result')[0].height = height
    $('.crop-result')[0].width = width
    var corped_image = $('.crop-result')[0]
    var canvas_context = corped_image.getContext("2d")
    var vision_image = $('.vision-screenshot')[0]
    canvas_context.drawImage(vision_image, x1, y1, width, height, 0, 0, width, height)
  }

  var dragx1 = 0
  var dragy1 = 0
  var dragx2 = 0
  var dragy2 = 0

  factor = () => {
    original_width = $('.vision-screenshot').prop('naturalWidth')
    screen_width = $('.vision-screenshot').width()
    return(parseFloat(original_width)/parseFloat(screen_width))
  }
  s = (dimension) => {
    return(parseInt(dimension*factor()))
  }
  reset_drag = () => {
    dragx1 = 0
    dragy1 = 0
    dragx2 = 0
    dragy2 = 0
    $('.vision-selection').css('display', 'none')
    $('.vision-selection').css('top', '0px')
    $('.vision-selection').css('left', '0px')
  }
  $('.vision-screenshot-overlay').mousedown((e) => {
    dragx1 = e.originalEvent.layerX
    dragy1 = e.originalEvent.layerY
    $('.vision-selection').css('display', 'inline')
  })

  $('.vision-screenshot-overlay').mouseup((e) => {
    dragx2 = e.originalEvent.layerX
    dragy2 = e.originalEvent.layerY
    crop(s(dragx1), s(dragy1), s(dragx2), s(dragy1 + dragx2 - dragx1))
    mx = parseInt(s(dragx1) + (s(dragx2)-s(dragx1))/2)
    my = parseInt(s(dragy1) + (s(dragy2)-s(dragy1))/2)
    $('.touch-point-x').val(mx)
    $('.touch-point-y').val(my)
    $('.midpoint').html(`${mx}:${my}`)
    reset_drag()
  })


  $(".vision-screenshot-overlay").mouseout((e) => {
    reset_drag()
    set_overlay_dimensions()
  })
  $(".vision-screenshot-overlay").mousemove( (e) => {
    var dragx = e.originalEvent.layerX
    var dragy = e.originalEvent.layerY
    $('.vision-selection').css('top', dragy1+'px')
    $('.vision-selection').css('left', dragx1+'px')
    $('.vision-selection').css('width', (dragx - dragx1)+'px')
    $('.vision-selection').css('height', (dragx - dragx1)+'px')
  })
})
