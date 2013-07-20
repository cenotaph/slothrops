class AddRecipientToExpenses < ActiveRecord::Migration
  def change
    add_column :expenses, :recipient, :string
  end
end
