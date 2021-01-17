class ReportNotifier < ApplicationJob

  def perform(user_id, test_id)
    
    @user = User.find(user_id)
    ApplicationCable::NotificationsChannel.broadcast_to(
      @user,
      message: "<a href='/test_scenarios/#{test_id}' target='_blank'>View Report</a>",
      target: "#report_link_#{test_id}"
    )
  end
end