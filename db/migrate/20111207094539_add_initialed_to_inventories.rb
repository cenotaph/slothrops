class AddInitialedToInventories < ActiveRecord::Migration
  def change
    add_column :inventories, :initialed, :string
  end
end
