class AddAttributesToTestScenarios < ActiveRecord::Migration[5.2]
  def change
    add_column :test_scenarios, :start_at, :datetime
    add_column :test_scenarios, :end_at, :datetime
    add_column :test_scenarios, :success, :boolean
  end
end
