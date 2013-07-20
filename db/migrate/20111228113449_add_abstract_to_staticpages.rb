class AddAbstractToStaticpages < ActiveRecord::Migration
  def change
    add_column :staticpages, :abstract, :text
  end
end
