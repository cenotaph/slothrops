class CreateConsignmentItems < ActiveRecord::Migration
  def change
    create_table :consignment_items do |t|
      t.references :edition
      t.float :price
      t.float :wholesale
      t.integer :stock_count
      t.date :acquired
      t.string :initialed
      t.references :consigner
      t.string :slug
      t.timestamps
    end
    add_index :consignment_items, :slug, :unique => true
    add_index :consignment_items, :edition_id
    add_index :consignment_items, :consigner_id
    
    create_table :consignment_sales do |t|
      t.references :consignment_item
      t.references :sale
    end
    
  end
  
end
