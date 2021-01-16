class TestScenarioRunner < ApplicationJob
  queue_as :default

  def perform(test_id, user_id, target)
    @test = TestScenario.find(test_id)
    @test.code.split(/\n/).each do |line|
      if line.starts_with?('delay')
        OutputSender.perform_later(user_id, line, '1', target)
        sleep(line.split(':').last.to_f)
      else
        Quaco.execute(user_id, line) if line.present?
      end
    end
  end
end