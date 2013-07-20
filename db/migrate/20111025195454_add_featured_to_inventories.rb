class AddFeaturedToInventories < ActiveRecord::Migration
  def change
    add_column :inventories, :featured, :boolean, :default => false, :null => false
  end
end
