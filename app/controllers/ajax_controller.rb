class AjaxController < ApplicationController
  def books
    if params[:term]
      like= "%".concat(params[:term].concat("%"))
      books = Book.where("title like ?", like)
      creators =  Creator.where("displayname like ?", like)
    else
      books = Book.all
    end
    list = books.map {|u| Hash[ id: u.id, label: u.title, name: u.title]}
    list += creators.map {|c| Hash[ id: c.id, label: c.displayname, name: c.displayname]}
    render json: list
  end

  def users
  end

  def creators
    if params[:term]
      like= "%".concat(params[:term].concat("%"))
      creators =  Creator.where("displayname like ?", like)
    else
      creators = Creator.all
    end
    list = creators.map {|c| Hash[ id: c.id, label: c.displayname, name: c.displayname]}
    render json: list
  end

end
