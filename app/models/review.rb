class Review < ActiveRecord::Base
  belongs_to :book, :counter_cache => true
  belongs_to :user
  extend FriendlyId
  friendly_id :review_title, :use => :slugged
  
  
  # def self.published(num = 3)
  #   where("published is true")
  #   order("created_at DESC")
  #   limit(num)
  # end
  
  def self.featured(num = 3)
    where("reviews.published is true and featured is true")
    order("created_at DESC")
    limit(num)
  end

  def title
    review_title
  end
  
end
