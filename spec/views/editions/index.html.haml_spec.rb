require 'spec_helper'

describe "editions/index.html.haml" do
  before(:each) do
    assign(:editions, [
      stub_model(Edition,
        :book => nil,
        :format => "Format",
        :product_description => "MyText",
        :amazoncode => 1
      ),
      stub_model(Edition,
        :book => nil,
        :format => "Format",
        :product_description => "MyText",
        :amazoncode => 1
      )
    ])
  end

  it "renders a list of editions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Format".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
