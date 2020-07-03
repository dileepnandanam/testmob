class AddDemoTimeframeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :start, :datetime
    add_column :users, :end, :datetime
  end
end
