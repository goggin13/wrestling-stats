require "rails_helper"

RSpec.describe WrestleBet::MatchesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/wrestle_bet/matches").to route_to("wrestle_bet/matches#index")
    end

    it "routes to #new" do
      expect(get: "/wrestle_bet/matches/new").to route_to("wrestle_bet/matches#new")
    end

    it "routes to #show" do
      expect(get: "/wrestle_bet/matches/1").to route_to("wrestle_bet/matches#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/wrestle_bet/matches/1/edit").to route_to("wrestle_bet/matches#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/wrestle_bet/matches").to route_to("wrestle_bet/matches#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/wrestle_bet/matches/1").to route_to("wrestle_bet/matches#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/wrestle_bet/matches/1").to route_to("wrestle_bet/matches#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/wrestle_bet/matches/1").to route_to("wrestle_bet/matches#destroy", id: "1")
    end
  end
end
