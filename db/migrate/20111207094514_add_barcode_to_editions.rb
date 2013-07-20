class AddBarcodeToEditions < ActiveRecord::Migration
  def change
    add_column :editions, :barcode, :string
  end
end
