class AddClosedToBookbuys < ActiveRecord::Migration
  def change
    add_column :bookbuys, :closed, :boolean
  end
end
