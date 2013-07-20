require 'spec_helper'

describe "books/show.html.haml" do
  before(:each) do
    @book = assign(:book, stub_model(Book,
      :category => nil,
      :creator => nil,
      :title => "Title",
      :format => "Format",
      :condition => "Condition",
      :notes => "MyText",
      :box => 1,
      :price => 1.5,
      :omahind => 1.5,
      :source => "Source",
      :amazoncode => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Format/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Condition/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1.5/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1.5/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Source/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
