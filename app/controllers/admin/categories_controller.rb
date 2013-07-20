class Admin::CategoriesController < Admin::BaseController
  
  def set_category
    inventory = Inventory.find(params[:inventory_id])
    cat = Category.find(params[:category_id])
    inventory.book.category = cat
    if inventory.book.save!
      render :text => cat.name
    else
      render :text => 'error setting category'
    end
  end
  
  def unset
    inventory = Inventory.find(params[:inventory_id])
    inventory.book.category = nil
    if inventory.book.save!
      render :text => 'unset!'
    else
      render :text => 'error'
    end
  end
  
end
