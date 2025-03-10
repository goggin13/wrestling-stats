require "rails_helper"

RSpec.describe WrestleBet::PropBetsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/wrestle_bet/prop_bets").to route_to("wrestle_bet/prop_bets#index")
    end

    it "routes to #new" do
      expect(get: "/wrestle_bet/prop_bets/new").to route_to("wrestle_bet/prop_bets#new")
    end

    it "routes to #show" do
      expect(get: "/wrestle_bet/prop_bets/1").to route_to("wrestle_bet/prop_bets#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/wrestle_bet/prop_bets/1/edit").to route_to("wrestle_bet/prop_bets#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/wrestle_bet/prop_bets").to route_to("wrestle_bet/prop_bets#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/wrestle_bet/prop_bets/1").to route_to("wrestle_bet/prop_bets#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/wrestle_bet/prop_bets/1").to route_to("wrestle_bet/prop_bets#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/wrestle_bet/prop_bets/1").to route_to("wrestle_bet/prop_bets#destroy", id: "1")
    end
  end
end
