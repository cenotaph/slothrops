class ChangePriceToDiscount < ActiveRecord::Migration
  def up
    rename_column :sales, :price, :discount
  end

  def down
    rename_column :sales, :discount, :price
  end
end
