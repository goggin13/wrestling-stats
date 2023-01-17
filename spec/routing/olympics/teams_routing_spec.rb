require "rails_helper"

RSpec.describe Olympics::TeamsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/olympics/teams").to route_to("olympics/teams#index")
    end

    it "routes to #new" do
      expect(get: "/olympics/teams/new").to route_to("olympics/teams#new")
    end

    it "routes to #show" do
      expect(get: "/olympics/teams/1").to route_to("olympics/teams#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/olympics/teams/1/edit").to route_to("olympics/teams#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/olympics/teams").to route_to("olympics/teams#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/olympics/teams/1").to route_to("olympics/teams#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/olympics/teams/1").to route_to("olympics/teams#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/olympics/teams/1").to route_to("olympics/teams#destroy", id: "1")
    end
  end
end
