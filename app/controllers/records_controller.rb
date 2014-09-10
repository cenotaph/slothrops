class RecordsController < InheritedResources::Base
  actions :show, :index
  has_scope :page, :default => 1
  
  before_filter :get_feed
  before_filter :get_recommended

  def index
    @records = Record.all.delete_if{|x| !x.in_stock? }
    set_meta_tags :title => 'Music'
  end

  def show
    @record = Record.find(params[:id])
    set_meta_tags :title => @record.full_title
  end
end