class AddAcquiredToInventories < ActiveRecord::Migration
  def change
    add_column :inventories, :acquired, :date
    execute('UPDATE inventories set acquired="1970-01-01"')
  end
 
end
