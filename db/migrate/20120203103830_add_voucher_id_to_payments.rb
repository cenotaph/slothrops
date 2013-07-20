class AddVoucherIdToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :voucher_id, :integer
    add_column :payments, :bookbuy_id, :integer
  end
end
