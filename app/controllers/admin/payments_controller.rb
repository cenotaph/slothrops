class Admin::PaymentsController < Admin::BaseController
  belongs_to :sale
  actions :new, :index, :create, :edit, :update
  
  def create 
    create! { [:admin, @payment.sale] }
  end
  
  def new
    @sale = Sale.find(params[:sale_id])
  end
  
  def update
    update! { [:admin, @payment.sale] }
  end
end