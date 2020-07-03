class AddMoreUserDetailsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :location, :string
    add_column :users, :company_name, :text
    add_column :users, :purpose, :text
    add_column :users, :prefered_timing, :text
  end
end
