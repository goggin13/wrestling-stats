 require 'rails_helper'


RSpec.describe "/wrestle_bet/wrestlers", type: :request do

  let(:invalid_attributes) {
    { name: "Meyer Shapiro", college_id: nil }
  }

  before do
    sign_in FactoryBot.create(:user, :admin)
    @college = FactoryBot.create(:college)
    @valid_attributes = { name: "Meyer Shapiro", college_id: @college.id }
  end

  describe "GET /index" do
    it "renders a successful response" do
      WrestleBet::Wrestler.create! @valid_attributes
      get wrestle_bet_wrestlers_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      wrestler = WrestleBet::Wrestler.create! @valid_attributes
      get wrestle_bet_wrestler_url(wrestler)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_wrestle_bet_wrestler_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      wrestler = WrestleBet::Wrestler.create! @valid_attributes
      get edit_wrestle_bet_wrestler_url(wrestler)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new WrestleBet::Wrestler" do
        expect {
          post wrestle_bet_wrestlers_url, params: { wrestle_bet_wrestler: @valid_attributes }
        }.to change(WrestleBet::Wrestler, :count).by(1)
      end

      it "redirects to the created wrestle_bet_wrestler" do
        post wrestle_bet_wrestlers_url, params: { wrestle_bet_wrestler: @valid_attributes }
        wrestler = WrestleBet::Wrestler.last!
        expect(response).to redirect_to(wrestle_bet_wrestler_url(wrestler ))
      end
    end

    context "with invalid parameters" do
      it "does not create a new WrestleBet::Wrestler" do
        expect {
          post wrestle_bet_wrestlers_url, params: { wrestle_bet_wrestler: invalid_attributes }
        }.to change(WrestleBet::Wrestler, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post wrestle_bet_wrestlers_url, params: { wrestle_bet_wrestler: invalid_attributes }
        expect(response.code).to eq("422")
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        { name: "Chris Foca", college_id: @college.id }
      }

      it "updates the requested wrestle_bet_wrestler" do
        wrestler = WrestleBet::Wrestler.create! @valid_attributes
        patch wrestle_bet_wrestler_url(wrestler), params: { wrestle_bet_wrestler: new_attributes }
        wrestler.reload
        expect(wrestler.name).to eq("Chris Foca")
      end

      it "redirects to the wrestle_bet_wrestler" do
        wrestler = WrestleBet::Wrestler.create! @valid_attributes
        patch wrestle_bet_wrestler_url(wrestler), params: { wrestle_bet_wrestler: new_attributes }
        wrestler.reload
        expect(response).to redirect_to(wrestle_bet_wrestler_url(wrestler))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        wrestler = WrestleBet::Wrestler.create! @valid_attributes
        patch wrestle_bet_wrestler_url(wrestler), params: { wrestle_bet_wrestler: invalid_attributes }
        expect(response.code).to eq("422")
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested wrestle_bet_wrestler" do
      wrestler = WrestleBet::Wrestler.create! @valid_attributes
      expect {
        delete wrestle_bet_wrestler_url(wrestler)
      }.to change(WrestleBet::Wrestler, :count).by(-1)
    end

    it "redirects to the wrestle_bet_wrestlers list" do
      wrestler = WrestleBet::Wrestler.create! @valid_attributes
      delete wrestle_bet_wrestler_url(wrestler)
      expect(response).to redirect_to(wrestle_bet_wrestlers_url)
    end
  end
end
