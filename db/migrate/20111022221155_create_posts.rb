class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user
      t.references :book
      t.references :creator
      t.string :subject
      t.text :body
      t.string :image
      t.string :slug
      t.timestamps
    end
    add_index :posts, :user_id
    add_index :posts, :book_id
    add_index :posts, :slug, :unique => true
  end
end
