class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name
      t.timestamps
    end
    execute('INSERT INTO roles (name) VALUES("SuperAdmin")')
    execute('INSERT INTO roles (name) VALUES("InventoryAdmin")')
    execute('INSERT INTO roles (name) VALUES("ContentAdmin")')
  end
 
  def self.down
    drop_table :roles
  end
  
  
end
 
