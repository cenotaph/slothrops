class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.references :category
      t.references :creator
      t.string :title
      t.string :slug
      t.timestamps
    end
    add_index :books, :category_id
    add_index :books, :creator_id

    add_index :books, :slug, :unique => true
  end
end
