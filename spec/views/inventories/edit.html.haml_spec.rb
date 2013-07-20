require 'spec_helper'

describe "inventories/edit.html.haml" do
  before(:each) do
    @inventory = assign(:inventory, stub_model(Inventory,
      :edition => nil,
      :condition => "MyString",
      :notes => "MyText",
      :box => 1,
      :price => 1.5,
      :omahind => 1.5,
      :source => "MyString",
      :image => "MyString",
      :slug => "MyString"
    ))
  end

  it "renders the edit inventory form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => inventories_path(@inventory), :method => "post" do
      assert_select "input#inventory_edition", :name => "inventory[edition]"
      assert_select "input#inventory_condition", :name => "inventory[condition]"
      assert_select "textarea#inventory_notes", :name => "inventory[notes]"
      assert_select "input#inventory_box", :name => "inventory[box]"
      assert_select "input#inventory_price", :name => "inventory[price]"
      assert_select "input#inventory_omahind", :name => "inventory[omahind]"
      assert_select "input#inventory_source", :name => "inventory[source]"
      assert_select "input#inventory_image", :name => "inventory[image]"
      assert_select "input#inventory_slug", :name => "inventory[slug]"
    end
  end
end
