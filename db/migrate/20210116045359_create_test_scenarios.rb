class CreateTestScenarios < ActiveRecord::Migration[5.2]
  def change
    create_table :test_scenarios do |t|
      t.text :code
      t.string :name

      t.timestamps
    end
  end
end
