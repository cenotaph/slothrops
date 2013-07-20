class RemovePaymenttypeFromSales < ActiveRecord::Migration
  def up
    remove_column :sales, :paymenttype_id
    remove_column :sales, :inventory_id
  end

  def down
    add_column :sales, :paymenttype_id, :integer
    add_column :sales, :inventory_id, :integer
  end
end
