class AddInvoicenumberToConsignmentItems < ActiveRecord::Migration
  def change
    add_column :consignment_items, :invoice_number, :string
  end
end
