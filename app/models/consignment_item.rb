class ConsignmentItem < ActiveRecord::Base
  mount_uploader :item_image, ImageUploader 
  belongs_to :edition
  belongs_to :record
  has_one :book, :through => :edition
  has_one :creator, :through => :book
  has_one :category, :through => :book
  belongs_to :consigner
  has_many :consignment_sales
  before_create :set_acquired
  attr_accessor :notweet
  after_create :check_twitter
  before_create :set_acquired
  extend FriendlyId
  friendly_id :inventory_entry, :use => :slugged  
  after_create :fix_slug
  validates_presence_of :stock_count, :wholesale
  validates_presence_of :consigner_id
  acts_as_taggable
  acts_as_taggable_on :collections
  


  def any_image(size = :midsize)
    if book.nil? && record.nil?
      item_image.url(size)
    end
  end

  def format
    if edition
      edition.format
    elsif record
      record.format
    else
      ''
    end
  end

  def reviews
    if book
      book.reviews
    else
      []
    end
  end

  def any_description
    if book
      book.any_description
    else
      item_description
    end
  end

  def items
    []
  end
  
  def check_twitter
    if notweet == "1"
      logger.warn('do not tweet')
    else
      if record.nil?
        Twitter.update(self.full_title + ": " + "http://slothrops.ee/consignment_items/#{self.slug}") rescue nil
      else
        Twitter.update(self.full_title + ": " + "http://slothrops.ee/records/#{self.slug}") rescue nil
      end
    end
  end
  
  def fix_slug
    save! if slug.blank?
  end
    
  def self.latest_arrivals
    includes([:books, :records])
    where("initialed is not null and price > 0")
  end
  
  def description
    if edition.nil?
      ""
    else
      edition.description
    end
  end
  
  
  def author
    if edition
      edition.book.creator_name
    end
  end
  
  def copies_sold
    consignment_sales.size
  end
  
  def condition
    ""
  end
  
  def notes
    ""
  end

  def image
    if item_image
      item_image
    else
      if edition.nil?
        if !record.nil?
          record.image 
        else
          nil
        end
      else
        edition.image
      end
    end
  end
  
  def inventory_entry
    if record.blank?
      if edition.blank?
        "#{name}--#{id}"
      else
        "#{author}--#{title}-#{id}"
      end
    else
      "#{record.artist}--#{record.title}-#{id}"
    end
  end  
  
  def our_comission
    copies_sold * (price - wholesale)
  end
  
  def owed_by_item
    (copies_sold * wholesale) - paid_and_collected_by_item
  end
  
  def paid_and_collected_by_item
    consignment_sales.reject{|x| x.payment_collected_at.nil? }.map{|x| x.consignment_item.wholesale}.sum
  end
  
  def potential_commission
    stock_count * (price - wholesale)
  end

  def remaining
    stock_count - consignment_sales.size
  end  
    
  def set_acquired
    if self.acquired.blank?
      self.acquired = Time.zone.now
    end
  end
  
  def in_stock?
    remaining > 0
  end

  def sold
    stock_count > 0 ? false : true
  end
     
  def sold?
    sold
  end
  
  def sale_id
    consignment_sales.empty? ? nil : consignment_sales.map(&:sale)
  end
  
  def title
    if edition.nil? && record.nil? && !name.nil?
      name
    elsif edition.nil? && !record.nil?
      record.full_title
    else
      edition.book.title
    end
  end
  
  def image
    if edition.nil?
      if !record.nil?
        record.image
      else
        nil
      end
    else
      edition.image
    end
  end
  
  def full_title
    if edition.nil?
      if !record.nil?
        record.full_title
      else
        name
      end
    else
      edition.book.full_title
    end
    # edition.book.creator_name.blank? ? title : title + " by " + edition.book.creator_name
  end
       
end
