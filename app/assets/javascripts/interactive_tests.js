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

  
})
