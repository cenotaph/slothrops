class AddCommentToSale < ActiveRecord::Migration
  def change
    add_column :sales, :comment, :text
  end
end
