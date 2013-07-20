class AddImageToConsignmentItems < ActiveRecord::Migration
  def change
    add_column :consignment_items, :item_image, :string
    add_column :consignment_items, :name, :string
    add_column :consignment_items, :item_description, :text
  end
end
