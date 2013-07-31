class Sale < ActiveRecord::Base
  belongs_to :user
  has_many :inventories
  has_many :consignment_items, :through => :consignment_sales
  has_many :consignment_sales, :dependent => :destroy
  has_many :vouchers, :dependent => :destroy
  has_many :payments, :dependent => :destroy
  validates_presence_of :user_id
  
  scope :opened, :conditions => {:sold_at => nil}
  scope :opened_for, ->(consigner_id) { includes(:consignment_sales => [:consignment_item => [:consigner]]).where(sold_at: nil, "consigners.id" => consigner_id) }
  scope :closed, where("sold_at is not null")
  scope :today, where("date(sold_at) = ?", Time.zone.now.strftime("%Y-%m-%d"))
  scope :this_week, where("date(sold_at) >= ? AND date(sold_at) <= ?", Time.zone.now.beginning_of_week.to_date.to_s, Time.zone.now.end_of_week.to_date.to_s)
  scope :this_month, where("date(sold_at) >= ? AND date(sold_at) <= ?", Time.zone.now.strftime("%Y-%m-01"), (Date.new((Date.today>>1).year,(Date.today>>1).month,1)-1).to_s)
  scope :any_period, lambda { |start_date, end_date| where("date(sold_at) >= ? AND date(sold_at) <= ?", start_date, end_date) }
  
  FILTERS = [
              {:scope => "all",       :label => "All"},
              {:scope => "opened",    :label => "Open"},
              
              {:scope => "closed", :label => "Completed"},
              {:scope => "today", :label => 'Today'},
              {:scope => "this_week", :label => 'This week'},
              {:scope => "this_month", :label => "This month"}
            ]


  def balance_due
    payments.empty? ? total_due : (total_due - payments_made)
  end
  
  def cash_payments
    cash_payments = payments.empty? ? 0 : payments.reject{|x| x.paymenttype_id != 1}.delete_if{|x| x.amount.nil?}.map{|x| x.amount.to_f}.sum
    credit_payments = payments.empty? ? 0 : payments.reject{|x| x.paymenttype_id != 2}.delete_if{|x| x.amount.nil?}.map{|x| x.amount.to_f}.sum 
    if to_consignee > 0.00
      cash_payments - to_consignee
    else
      cash_payments
    end
  end

  
  def to_consignee
    consignment_items.map(&:wholesale).sum
  end
  
  def credit_payments
    # if to_consignee > 0.00
    #   cp = payments.empty? ? 0 : payments.reject{|x| x.paymenttype_id != 2}.delete_if{|x| x.amount.nil?}.map{|x| x.amount.to_f}.sum 
    #   cp > to_consignee ? (cp - to_consignee) : 0.00
    # else
      payments.empty? ? 0 : payments.reject{|x| x.paymenttype_id != 2}.delete_if{|x| x.amount.nil?}.map{|x| x.amount.to_f}.sum 
    # end
  end
  
  def complete!
    unless consignment_sales.empty?
      consignment_sales.each do |cs|
        cs.consignment_item.consigner.consignment_sales_count += 1
        cs.consignment_item.consigner.save!
      end
    end

    if balance_due.to_f == 0
      self.sold_at = Time.zone.now
      items.each do |i|
        if i.class == Inventory
          i.sold = true
          i.save
        end
      end
      save!
      return true
    else
      return false
    end
  end
      
  def completed?
    if self.sold_at.blank? || self.balance_due > 0
      return false
    else
      return true
    end
  end
  
  def max_allowable_credit_before
    sprintf("%.2f", total_due - to_consignee).to_f 
  end
  
  def max_allowable_credit
    sprintf("%.2f", total_due - to_consignee).to_f - credit_payments
  end
  
  def open?
    if self.sold_at.blank? || self.balance_due > 0
      return true
    else
      return false
    end
  end

  def other_payments
    payments.empty? ? 0 : payments.reject{|x| x.paymenttype_id < 3}.delete_if{|x| x.amount.nil?}.map{|x| x.amount.to_f}.sum 
  end
  
  
  def payments_made
    payments.empty? ? 0 : payments.map{|x| x.amount.to_f}.inject(:+)
  end
  
  def total_due
    if items.empty? && vouchers.empty?
      0
    elsif items.empty?
      vouchers.map(&:amount).inject(:+) - discount.to_f
    elsif vouchers.empty?
      items.map(&:price).inject(:+).to_f - discount.to_f
    else
      items.map(&:price).inject(:+) + vouchers.map{|x| x.amount.to_f }.inject(:+) - discount.to_f
    end
  end
  
  def items
    inventories + consignment_items
  end

  
end
