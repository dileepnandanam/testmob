class CreateApiDocs < ActiveRecord::Migration[5.2]
  def change
    create_table :api_docs do |t|
      t.text :content
      t.string :name

      t.timestamps
    end
  end
end
