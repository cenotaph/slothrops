class Admin::MusiccategoriesController < Admin::BaseController
  def create 
    create! { admin_musiccategories_path }
  end

  def update
    update! { admin_musiccategories_path }
  end
  
end