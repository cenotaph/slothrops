require 'spec_helper'

describe "creators/show.html.haml" do
  before(:each) do
    @creator = assign(:creator, stub_model(Creator,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
