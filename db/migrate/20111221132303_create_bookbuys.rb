class CreateBookbuys < ActiveRecord::Migration
  def change
    create_table :bookbuys do |t|
      t.references :user
      t.date :day_of_sale
      t.float :amount
      t.string :source
      t.text :notes
      t.float :creditamt

      t.timestamps
    end
    add_index :bookbuys, :user_id
    add_column :inventories, :bookbuy_id, :integer
  end
end
