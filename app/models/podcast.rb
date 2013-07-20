class Podcast < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  has_many :podcastlinks
  accepts_nested_attributes_for :podcastlinks, :allow_destroy => true, :reject_if => proc { |attributes| attributes['name'].blank? }
  extend FriendlyId
  friendly_id :name_and_number, :use => :slugged
  validates_presence_of :name, :description, :number
  
  scope :published, -> { where(:published => true).order('number DESC') }
  
  def keywords
    description.gsub(/binx bolling/i, '').gsub(/dave hollins/i, '').gsub(/hy grynszpan/i, '').gsub(/discuss/, '').split(',').each(&:strip!)
  end
  
  def name_and_number
    "#{number}-#{name}"
  end
  
end
