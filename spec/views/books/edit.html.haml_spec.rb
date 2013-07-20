require 'spec_helper'

describe "books/edit.html.haml" do
  before(:each) do
    @book = assign(:book, stub_model(Book,
      :category => nil,
      :creator => nil,
      :title => "MyString",
      :format => "MyString",
      :condition => "MyString",
      :notes => "MyText",
      :box => 1,
      :price => 1.5,
      :omahind => 1.5,
      :source => "MyString",
      :amazoncode => 1
    ))
  end

  it "renders the edit book form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => books_path(@book), :method => "post" do
      assert_select "input#book_category", :name => "book[category]"
      assert_select "input#book_creator", :name => "book[creator]"
      assert_select "input#book_title", :name => "book[title]"
      assert_select "input#book_format", :name => "book[format]"
      assert_select "input#book_condition", :name => "book[condition]"
      assert_select "textarea#book_notes", :name => "book[notes]"
      assert_select "input#book_box", :name => "book[box]"
      assert_select "input#book_price", :name => "book[price]"
      assert_select "input#book_omahind", :name => "book[omahind]"
      assert_select "input#book_source", :name => "book[source]"
      assert_select "input#book_amazoncode", :name => "book[amazoncode]"
    end
  end
end
