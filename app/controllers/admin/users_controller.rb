class Admin::UsersController < Admin::BaseController
  has_scope :page, :default => 1
  
  def update
    update! { admin_users_path }
  end
  
end
