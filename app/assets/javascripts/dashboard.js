$(document).on('turbolinks:load', function() {
  //$('.code form').on('ajax:success', function(e) {
  //  $('.result').html(e.detail[2].responseText)
  //})

  $('.submit-code').click(function() {
    $('.result').html('Executing...')
  })

})