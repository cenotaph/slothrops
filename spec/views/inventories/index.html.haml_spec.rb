require 'spec_helper'

describe "inventories/index.html.haml" do
  before(:each) do
    assign(:inventories, [
      stub_model(Inventory,
        :edition => nil,
        :condition => "Condition",
        :notes => "MyText",
        :box => 1,
        :price => 1.5,
        :omahind => 1.5,
        :source => "Source",
        :image => "Image",
        :slug => "Slug"
      ),
      stub_model(Inventory,
        :edition => nil,
        :condition => "Condition",
        :notes => "MyText",
        :box => 1,
        :price => 1.5,
        :omahind => 1.5,
        :source => "Source",
        :image => "Image",
        :slug => "Slug"
      )
    ])
  end

  it "renders a list of inventories" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Condition".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Source".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Image".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Slug".to_s, :count => 2
  end
end
