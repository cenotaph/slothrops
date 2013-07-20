require 'spec_helper'

describe "posts/new.html.haml" do
  before(:each) do
    assign(:post, stub_model(Post,
      :user => nil,
      :book => nil,
      :subject => "MyString",
      :body => "MyText",
      :image => "MyString"
    ).as_new_record)
  end

  it "renders new post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => posts_path, :method => "post" do
      assert_select "input#post_user", :name => "post[user]"
      assert_select "input#post_book", :name => "post[book]"
      assert_select "input#post_subject", :name => "post[subject]"
      assert_select "textarea#post_body", :name => "post[body]"
      assert_select "input#post_image", :name => "post[image]"
    end
  end
end
