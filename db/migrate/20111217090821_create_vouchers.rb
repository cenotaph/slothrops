class CreateVouchers < ActiveRecord::Migration
  def change
    create_table :vouchers do |t|
      t.date :sold_at
      t.string :number
      t.float :amount
      t.references :user
      t.references :sale
      t.timestamps
    end
    # add_column :payments, :voucher_id, :integer
     
  end
end
