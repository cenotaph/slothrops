class AddConsignmentsalescountToConsigners < ActiveRecord::Migration
  def change
    add_column :consigners, :consignment_sales_count, :integer
    Consigner.reset_column_information
    Consigner.find(:all).each do |p|
      p.update_attribute(:consignment_sales_count, p.consignment_sales.size)
    end
  end
end
