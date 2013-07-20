class ConsignerMailer < ActionMailer::Base
  def item_sold(ci)
    @ci = ci
    mail(:to => ci.consigner.email, :subject => "Item(s) sold at Slothrop's", :from => "info@slothrops.ee")
  end
end
