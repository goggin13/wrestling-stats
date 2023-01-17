 require 'rails_helper'

RSpec.describe "/teams", type: :request do
  
  let(:valid_attributes) {
    {
      name: "Goggin & Jake",
      number: 1,
    }
  }

  let(:invalid_attributes) {
    {
      name: nil
    }
  }

  before do
    sign_in FactoryBot.create(:user, :admin)
  end

  describe "GET /index" do
    it "renders a successful response" do
      Olympics::Team.create! valid_attributes
      get olympics_teams_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      team = Olympics::Team.create! valid_attributes
      get olympics_team_url(team)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_olympics_team_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      team = Olympics::Team.create! valid_attributes
      get edit_olympics_team_url(team)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Olympics::Team" do
        expect {
          post olympics_teams_url, params: { olympics_team: valid_attributes }
        }.to change(Olympics::Team, :count).by(1)

        team = Olympics::Team.last
        expect(team.name).to eq("Goggin & Jake")
        expect(team.number).to eq(1)
      end

      it "redirects to the created olympics_team" do
        post olympics_teams_url, params: { olympics_team: valid_attributes }
        expect(response).to redirect_to(olympics_team_url(Olympics::Team.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Olympics::Team" do
        expect {
          post olympics_teams_url, params: { olympics_team: invalid_attributes }
        }.to change(Olympics::Team, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post olympics_teams_url, params: { olympics_team: invalid_attributes }
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {name: "Goggin & Eric"}
      }

      it "updates the requested olympics_team" do
        team = Olympics::Team.create! valid_attributes
        patch olympics_team_url(team), params: { olympics_team: new_attributes }
        team.reload
        expect(team.name).to eq("Goggin & Eric")
      end

      it "redirects to the olympics_team" do
        team = Olympics::Team.create! valid_attributes
        patch olympics_team_url(team), params: { olympics_team: new_attributes }
        team.reload
        expect(response).to redirect_to(olympics_team_url(team))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        team = Olympics::Team.create! valid_attributes
        patch olympics_team_url(team), params: { olympics_team: invalid_attributes }
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested olympics_team" do
      team = Olympics::Team.create! valid_attributes
      expect {
        delete olympics_team_url(team)
      }.to change(Olympics::Team, :count).by(-1)
    end

    it "redirects to the teams list" do
      team = Olympics::Team.create! valid_attributes
      delete olympics_team_url(team)
      expect(response).to redirect_to(olympics_teams_url)
    end
  end
end
