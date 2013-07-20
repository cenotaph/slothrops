require 'spec_helper'

describe "creators/new.html.haml" do
  before(:each) do
    assign(:creator, stub_model(Creator,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new creator form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => creators_path, :method => "post" do
      assert_select "input#creator_name", :name => "creator[name]"
    end
  end
end
