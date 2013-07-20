class Record < ActiveRecord::Base
  has_many :consignment_items
  belongs_to :musiccategory
  mount_uploader :image, ImageUploader
  accepts_nested_attributes_for :consignment_items
  after_save :get_discogs_image
  acts_as_taggable
  acts_as_taggable_on :collections
  extend FriendlyId
  friendly_id :artist_and_title, :use => :slugged
  acts_as_taggable_on
  acts_as_taggable_on :collections
  has_one :consigner, :through => :consignment_items


  def artist_and_title
    "#{artist}--#{title}--#{id}"
  end

  def author
    artist
  end

  def any_image(size = :midsize)
    self.image.url(size)
  end

  def reviews
    []
  end

  def any_description
    ''
  end

  def category
    musiccategory
  end
  

  def items 
    consignment_items
  end


  def get_discogs_image
    require 'discogs'
    if self.image.blank?
      unless discogs_id.blank? && master_id.blank?
        m = Discogs::Wrapper.new('f6d728eef1').get_release((discogs_id.blank? ? master_id : discogs_id))
        unless m.nil?
          unless m.images.blank?
            self.remote_image_url = m.images.first.uri150
            self.save!
          end
        end
      end
    end
  end

  def in_stock?
    consignment_items.map{|x| x.in_stock? }.flatten.include?(true)
  end

  def inventories
    []
  end

  def full_title
    artist + ' / ' + title + ' (' + format + ', ' + label + ')'
  end
  
end