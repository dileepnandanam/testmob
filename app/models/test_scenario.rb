class TestScenario < ApplicationRecord
  def self.for(name)
    where(name: name).first_or_create
  end
end
