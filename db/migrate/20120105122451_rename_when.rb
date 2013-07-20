class RenameWhen < ActiveRecord::Migration
  def up
    rename_column :expenses, :when, :expense_date
  end

  def down
    rename_column :expenses, :expense_date, :when
  end
end
