require "rails_helper"

RSpec.describe WrestleBet::WrestlersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/wrestle_bet/wrestlers").to route_to("wrestle_bet/wrestlers#index")
    end

    it "routes to #new" do
      expect(get: "/wrestle_bet/wrestlers/new").to route_to("wrestle_bet/wrestlers#new")
    end

    it "routes to #show" do
      expect(get: "/wrestle_bet/wrestlers/1").to route_to("wrestle_bet/wrestlers#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/wrestle_bet/wrestlers/1/edit").to route_to("wrestle_bet/wrestlers#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/wrestle_bet/wrestlers").to route_to("wrestle_bet/wrestlers#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/wrestle_bet/wrestlers/1").to route_to("wrestle_bet/wrestlers#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/wrestle_bet/wrestlers/1").to route_to("wrestle_bet/wrestlers#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/wrestle_bet/wrestlers/1").to route_to("wrestle_bet/wrestlers#destroy", id: "1")
    end
  end
end
