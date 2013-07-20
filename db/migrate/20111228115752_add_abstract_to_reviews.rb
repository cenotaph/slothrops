class AddAbstractToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :abstract, :text
  end
end
