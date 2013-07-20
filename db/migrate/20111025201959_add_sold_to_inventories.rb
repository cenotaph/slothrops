class AddSoldToInventories < ActiveRecord::Migration
  def change
    add_column :inventories, :sold, :boolean, :default => false, :null => false
  end
end
