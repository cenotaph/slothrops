class AddConditionToConsignmentItems < ActiveRecord::Migration
  def change
    add_column :consignment_items, :condition, :string
    add_column :consignment_items, :record_id, :integer
  end
end
