class Admin::TagsController < Admin::BaseController

  def update
    @tag = Tag.find params[:id]

    respond_to do |format|
      if @tag.update_attributes(params[:tag])
        format.html { redirect_to(@tag, :notice => 'Tag was successfully updated.') }
        format.json { respond_with_bip(@tag) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@tag) }
      end
    end
  end
  
end