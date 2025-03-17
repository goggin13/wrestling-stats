require "rails_helper"

RSpec.describe WrestleBet::SpreadBetsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/wrestle_bet/spread_bets").to route_to("wrestle_bet/spread_bets#index")
    end

    it "routes to #new" do
      expect(get: "/wrestle_bet/spread_bets/new").to route_to("wrestle_bet/spread_bets#new")
    end

    it "routes to #show" do
      expect(get: "/wrestle_bet/spread_bets/1").to route_to("wrestle_bet/spread_bets#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/wrestle_bet/spread_bets/1/edit").to route_to("wrestle_bet/spread_bets#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/wrestle_bet/spread_bets").to route_to("wrestle_bet/spread_bets#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/wrestle_bet/spread_bets/1").to route_to("wrestle_bet/spread_bets#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/wrestle_bet/spread_bets/1").to route_to("wrestle_bet/spread_bets#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/wrestle_bet/spread_bets/1").to route_to("wrestle_bet/spread_bets#destroy", id: "1")
    end
  end
end
