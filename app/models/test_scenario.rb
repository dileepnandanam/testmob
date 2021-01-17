class TestScenario < ApplicationRecord
  def self.for(name)
    where(name: name).first_or_create
  end

  def duration
    (end_at - start_at).to_i
  end
end
