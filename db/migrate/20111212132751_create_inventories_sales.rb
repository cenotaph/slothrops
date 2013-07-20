class CreateInventoriesSales < ActiveRecord::Migration
  def up
    add_column :inventories, :sale_id, :integer, :default => nil
    
  end

  def down
    drop_column :inventories, :sale_id
  end
end
