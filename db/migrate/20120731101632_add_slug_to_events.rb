class AddSlugToEvents < ActiveRecord::Migration
  def change
    add_column :events, :slug, :string
    add_column :events, :facebook, :string
    Event.find_each(&:save!)
  end
end
