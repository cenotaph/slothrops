class AddImageattriutesToImages < ActiveRecord::Migration
  def change
    add_column :editions, :image_size, :bigint
    add_column :editions, :image_content_type, :string
    add_column :editions, :image_height, :integer
    add_column :editions, :image_width, :integer
    add_column :inventories, :image_size, :bigint
    add_column :inventories, :image_content_type, :string
    add_column :inventories, :image_height, :integer
    add_column :inventories, :image_width, :integer
    add_column :consignment_items, :item_image_size, :bigint
    add_column :consignment_items, :item_image_content_type, :string
    add_column :consignment_items, :item_image_height, :integer
    add_column :consignment_items, :item_image_width, :integer            
    add_column :records, :image_size, :bigint
    add_column :records, :image_content_type, :string
    add_column :records, :image_height, :integer
    add_column :records, :image_width, :integer
  end
end
