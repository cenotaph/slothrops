class AddContactnameToConsigners < ActiveRecord::Migration
  def change
    add_column :consigners, :contact_name, :string
    add_column :consigners, :report_info, :string
  end
end
