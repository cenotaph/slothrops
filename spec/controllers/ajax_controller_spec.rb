require 'spec_helper'

describe AjaxController do

  describe "GET 'books'" do
    it "should be successful" do
      get 'books'
      response.should be_success
    end
  end

  describe "GET 'users'" do
    it "should be successful" do
      get 'users'
      response.should be_success
    end
  end

  describe "GET 'creators'" do
    it "should be successful" do
      get 'creators'
      response.should be_success
    end
  end

end
