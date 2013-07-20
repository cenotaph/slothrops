class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string :artist
      t.string :title
      t.string :label
      t.string :format
      t.string :image
      t.string :slug
      t.string :catalog
      t.integer :year
      t.integer :master_id
      t.integer :musiccategory_id

      t.timestamps
    end
    add_index :records, :slug, :unique => true
  end
end
