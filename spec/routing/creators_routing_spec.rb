require "spec_helper"

describe CreatorsController do
  describe "routing" do

    it "routes to #index" do
      get("/creators").should route_to("creators#index")
    end

    it "routes to #new" do
      get("/creators/new").should route_to("creators#new")
    end

    it "routes to #show" do
      get("/creators/1").should route_to("creators#show", :id => "1")
    end

    it "routes to #edit" do
      get("/creators/1/edit").should route_to("creators#edit", :id => "1")
    end

    it "routes to #create" do
      post("/creators").should route_to("creators#create")
    end

    it "routes to #update" do
      put("/creators/1").should route_to("creators#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/creators/1").should route_to("creators#destroy", :id => "1")
    end

  end
end
