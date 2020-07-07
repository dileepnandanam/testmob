notification_channel_subscribed = undefined
$(document).on('turbolinks:load', function() {
  if(!notification_channel_subscribed) {
    App.cable.subscriptions.create("ApplicationCable::NotificationsChannel", {
      received(data) {
        $('.result-inner').append(data.message)
        $('.result-inner').scrollTop($('.result-inner').prop('scrollHeight'))
      }
    })
    notification_channel_subscribed = 1
  }
})