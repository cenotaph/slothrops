class Admin::EventsController < Admin::BaseController
  def create
    create! { admin_events_path }
  end
  
  def update
    update! { admin_events_path }
  end
end
