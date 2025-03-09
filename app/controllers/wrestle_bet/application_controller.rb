class WrestleBet::ApplicationController < ApplicationController
  layout "wrestle_bet/application"
  before_action :set_tournament

  def set_tournament
    @tournament = WrestleBet::Tournament.first
  end
end
