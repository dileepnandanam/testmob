$(document).on('turbolinks:load', function() {
  //$('.code form').on('ajax:success', function(e) {
  //  $('.result').html(e.detail[2].responseText)
  //})

  $('.submit-code').click(function() {
    $('.result').html('Executing...')
  })

  $(document).on('ajax:success', '.nav-link', function(e) {
    $('.interactive-ui').replaceWith(e.detail[2].responseText)
    addSubmitEvent()
  })

  $(document).on('ajax:success', '.schedule-demo-request', function(e) {
    $(this).siblings('.schedule-demo-request-form').html(e.detail[2].responseText)
    $('.datetime_picker').datetimepicker();
  })

  $(document).on('click', '.cancel-form', function(e) {
    $(this).closest('form').remvoe()
    e.preventDefault()
  })


})