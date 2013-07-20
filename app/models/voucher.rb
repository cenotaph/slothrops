class Voucher < ActiveRecord::Base
  belongs_to :user
  belongs_to :sale, :counter_cache => true
  has_many :payments
  
  def used
    if payments.blank?
      0
    else
      payments.map{|x| x.amount.to_f}.sum
    end
  end
  
  def left
    amount - used
  end
  
end
