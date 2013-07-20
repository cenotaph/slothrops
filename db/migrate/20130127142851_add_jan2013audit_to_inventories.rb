class AddJan2013auditToInventories < ActiveRecord::Migration
  def change
    add_column :inventories, :jan2013audit, :boolean
  end
end
