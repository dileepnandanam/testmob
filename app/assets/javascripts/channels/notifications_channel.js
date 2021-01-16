notification_channel_subscribed = undefined
$(document).on('turbolinks:load', function() {
  if(!notification_channel_subscribed) {
    App.cable.subscriptions.create("ApplicationCable::NotificationsChannel", {
      received(data) {
        $(data.target).append(data.message)
        $(data.target).scrollTop($(data.target).prop('scrollHeight'))
      }
    })
    notification_channel_subscribed = 1
  }
})