class User < ActiveRecord::Base
  has_many :authentications  
  has_many :posts
  has_many :sales
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :image, :username
  mount_uploader :image, ImageUploader
  has_and_belongs_to_many :roles
  extend FriendlyId
  friendly_id :username, :use => :slugged
  
  ROLES = %w[super_admin inventory_admin user]
  
  def apply_omniauth(omniauth)
    logger.warn(omniauth.inspect)
    if omniauth['provider'] == 'twitter'
      self.username = omniauth['user_info']['nickname']
      self.real_name = omniauth['user_info']['name']
      self.real_name.strip!
      self.location = omniauth['user_info']['location']
      self.about_me = omniauth['user_info']['description']
      self.website = omniauth['user_info']['urls']['Website'] if website.blank?
    elsif omniauth['provider'] == 'facebook'
      self.email = omniauth['info']['email'] if email.blank?
      self.username = omniauth['info']['nickname']
      self.real_name = omniauth['info']['first_name'] + ' ' + omniauth['info']['last_name']
      self.real_name.strip!
      # self.location = omniauth['extra']['user_hash']['location']['name'] if location.blank?
    end
    self.email = omniauth['user_info']['email'] if email.blank?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
  
  def role?(role)
      return !!self.roles.find_by_name(role.to_s.camelize)
  end

end
