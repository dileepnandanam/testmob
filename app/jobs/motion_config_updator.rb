class MotionConfigUpdator < ApplicationJob
  def perform
    sleep(10)
    MotionConf.update
  end
end