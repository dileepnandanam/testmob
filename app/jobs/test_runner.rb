class TestRunner < ApplicationJob
  queue_as :default

  def perform(test_id, target)
    @test = Test.find(test_id)
    @test.code.split(/\n/).each do |line|
      if line.starts_with?('delay')
        OutputSender.perform_later(@test.user_id, line, '1', target)
        sleep(line.split(':').last.to_f)
      else
        Quaco.execute(@test.user_id, line, target) if line.present?
      end
    end
  end
end