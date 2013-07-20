class CreateEditions < ActiveRecord::Migration
  def change
    create_table :editions do |t|
      t.references :book
      t.string :format
      t.text :product_description
      t.string :amazoncode
      t.string :image
      t.timestamps
    end
    add_index :editions, :book_id
  end
end
