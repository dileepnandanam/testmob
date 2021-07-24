notification_channel_subscribed = undefined
$(document).on('turbolinks:load', function() {
  if(!notification_channel_subscribed) {
    App.cable.subscriptions.create("ApplicationCable::NotificationsChannel", {
      received(data) {
        if(data.message == 'meter_tests_finished') {
          $.getScript('/meter_tests/get_ocr_result')
        } else {
          $(data.target).append(data.message)
          $(data.target).scrollTop($(data.target).prop('scrollHeight'))
        }
      }
    })
    notification_channel_subscribed = 1
  }
})