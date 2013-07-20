require 'spec_helper'

describe "editions/show.html.haml" do
  before(:each) do
    @edition = assign(:edition, stub_model(Edition,
      :book => nil,
      :format => "Format",
      :product_description => "MyText",
      :amazoncode => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Format/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
