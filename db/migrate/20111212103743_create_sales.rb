class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.references :user
      t.references :paymenttype
      t.references :inventory
      t.float :price
      t.string :discount_reason
      t.datetime :sold_at

      t.timestamps
    end
    add_index :sales, :user_id
    add_index :sales, :paymenttype_id
  end
end
