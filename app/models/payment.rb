class Payment < ActiveRecord::Base
  belongs_to :paymenttype
  belongs_to :sale, :counter_cache => true
  belongs_to :voucher
  belongs_to :bookbuy, :counter_cache => true
  validates_presence_of :amount
  
  validate :check_credit_against_consigment
  
  def check_credit_against_consigment
    if paymenttype_id == 2
      if bookbuy_id.blank?
        errors[:bookbuy] << "You must choose who's credit this is!"
      end
      if sale.max_allowable_credit < sale.total_due
        if amount > sale.max_allowable_credit
          errors[:amount] << "Credit cannot exceed " + sprintf("%.2f", sale.max_allowable_credit.to_s) + "!!!"
        end
      end
    end
  end
  
end
