class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.references :edition
      t.string :condition
      t.text :notes
      t.integer :box
      t.float :price
      t.float :omahind
      t.string :source
      t.string :image
      t.string :slug

      t.timestamps
    end
    add_index :inventories, :edition_id
    add_index :inventories, :slug, :unique => true
  end
end
