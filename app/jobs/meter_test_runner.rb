class MeterTestRunner < ApplicationJob
  queue_as :default

  def perform(test_id, user_id, target)
    @test = TestScenario.find(test_id)
    @test.update(start_at: Time.now)
    results = []
    lines = @test.code.split(/\n/)
    lines.each do |line|
      if Quaco.closed?
        OutputSender.perform_later(user_id, 'disconnected', '', target)
        break
      end
      if line.starts_with?('delay')
        OutputSender.perform_later(user_id, line, '1', 'target')
        sleep(line.split(':').last.to_f)
        result = '1'
      elsif
        line.starts_with?('comment')
        OutputSender.perform_later(user_id, line.split(':').last, '', target)
        result = '1'
      else
        result = Quaco.execute(user_id, line, 'invalid_target') if line.present?
      end
      results << result
    end
    success = (results.count == lines.count)
    @test.update(end_at: Time.now, success: success)
    OutputSender.perform_later(user_id, 'meter_tests_finished', '1', target)
  end
end