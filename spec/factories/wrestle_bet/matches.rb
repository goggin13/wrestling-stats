FactoryBot.define do
  factory :wrestle_bet_match, class: 'WrestleBet::Match' do
    weight { 1 }
    started { false }
    home_wrestler_id { 1 }
    away_wrestler_id { 1 }
    home_score { 1 }
    away_score { 1 }
    tournament_id { 1 }
  end
end
