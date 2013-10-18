class AddLegitToConsigners < ActiveRecord::Migration
  def change
    add_column :consigners, :legit, :boolean, :default => false, :null => false
    add_column :consigners, :email_on_every_sale, :boolean, :default => true, :null => false
  end
end
