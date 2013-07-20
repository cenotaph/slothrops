class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :book
      t.string :review_title
      t.references :user
      t.string :reviewer_name
      t.text :body
      t.string :slug
      t.boolean :published
      t.boolean :featured

      t.timestamps
    end
    add_index :reviews, :book_id
    add_index :reviews, :user_id
  end
end
