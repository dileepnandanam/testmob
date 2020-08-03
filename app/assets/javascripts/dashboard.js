focusAlternative = function() {
  $('button').click(function(event) {
    $(this).focus()
  })
}
$(document).on('turbolinks:load', function() {
  //$('.code form').on('ajax:success', function(e) {
  //  $('.result').html(e.detail[2].responseText)
  //})

    addSubmitEvent()
    focusAlternative()

  $('.submit-code').click(function() {
    $('.result-status').html('Executing...')
  })

  $(document).on('ajax:success', '.nav-link', function(e) {
    $('.interactive-ui').replaceWith(e.detail[2].responseText)
    addSubmitEvent()
    focusAlternative()
  })

  $(document).on('ajax:success', '.schedule-demo-request', function(e) {
    $(this).siblings('.schedule-demo-request-form').html(e.detail[2].responseText)
    $('.datetime_picker').datetimepicker();
  })

  $(document).on('click', '.cancel-form', function(e) {
    $(this).closest('form').remvoe()
    e.preventDefault()
  })
  
  if($('#capture').length > 0 && false) {
    var socket = io.connect('quaco.sastrarobotics.com');
    socket.on('image',(data)=>{
      const image = document.getElementById("capture");
      image.src = `data:image/jpeg;base64,${data}`;
    });
  }

})