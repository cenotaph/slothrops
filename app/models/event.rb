class Event < ActiveRecord::Base
  scope :published, where(:published => true)
  scope :in_future, where(["start_at >= ?", Time.zone.now])
  extend FriendlyId
  friendly_id :title, :use => :slugged
  default_scope where(:published => true).order('start_at DESC')
end
