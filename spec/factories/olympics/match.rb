FactoryBot.define do
  factory :olympics_match, class: 'Olympics::Match' do
    sequence(:bout_number) { |n| n }
    team_1 factory: :olympics_team
    team_2 factory: :olympics_team
    event { Olympics::Match::Events::BEER_PONG }

    trait :beer_pong do
      event { Olympics::Match::Events::BEER_PONG }
    end

    trait :flip_cup do
      event { Olympics::Match::Events::FLIP_CUP }
    end

    trait :won do
      winning_team factory: :olympics_team
    end

    trait :now_playing do
      now_playing { true }
    end
  end
end
