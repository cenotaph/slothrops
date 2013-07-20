class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :paymenttype
      t.references :sale
      t.string :note
      t.float :amount

      t.timestamps
    end
    add_index :payments, :paymenttype_id
    add_index :payments, :sale_id
  end
end
