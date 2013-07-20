class Admin::BookbuysController < Admin::BaseController

  def index
    @bookbuys = Bookbuy.includes([:payments, {:inventories => :sale}])
  end
  
end
