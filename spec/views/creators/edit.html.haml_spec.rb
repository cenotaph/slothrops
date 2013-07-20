require 'spec_helper'

describe "creators/edit.html.haml" do
  before(:each) do
    @creator = assign(:creator, stub_model(Creator,
      :name => "MyString"
    ))
  end

  it "renders the edit creator form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => creators_path(@creator), :method => "post" do
      assert_select "input#creator_name", :name => "creator[name]"
    end
  end
end
