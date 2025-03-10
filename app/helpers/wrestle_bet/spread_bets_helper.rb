module WrestleBet::SpreadBetsHelper
  def user_betslip_link(user, tournament)
    link_to(
      user.email,
      wrestle_bet_betslip_url(id: tournament.id, c: user.encoded_email)
    )
  end
end
