require 'spec_helper'

describe "editions/edit.html.haml" do
  before(:each) do
    @edition = assign(:edition, stub_model(Edition,
      :book => nil,
      :format => "MyString",
      :product_description => "MyText",
      :amazoncode => 1
    ))
  end

  it "renders the edit edition form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => editions_path(@edition), :method => "post" do
      assert_select "input#edition_book", :name => "edition[book]"
      assert_select "input#edition_format", :name => "edition[format]"
      assert_select "textarea#edition_product_description", :name => "edition[product_description]"
      assert_select "input#edition_amazoncode", :name => "edition[amazoncode]"
    end
  end
end
