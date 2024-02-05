require 'rails_helper'

module Olympics
  RSpec.describe ScoreboardPresenter, type: :model do
    describe "sort_within_event" do
      it "yields a unique set of first 3 games for 6 competitors" do
        generator = Generator.new([1,2,3,4,5,6])

        event_games = [
          Generator::GeneratedMatch.new(2, 4),
          Generator::GeneratedMatch.new(1, 5),
          Generator::GeneratedMatch.new(3, 4),
          Generator::GeneratedMatch.new(2, 6),
          Generator::GeneratedMatch.new(1, 6),
          Generator::GeneratedMatch.new(3, 4),
        ]

        sorted = generator.sort_within_event(event_games)

        competitors_in_first_three_matches = sorted[0..2].inject([]) do |acc, match|
          acc << match.team_1
          acc << match.team_2

          acc
        end

        expect(competitors_in_first_three_matches.uniq.sort).to eq([1,2,3,4,5,6])
      end

      it "yields a unique set of first 3 games for 5 competitors" do
        generator = Generator.new([1,2,3,4,5])

        event_games = [
          Generator::GeneratedMatch.new(1, 4),
          Generator::GeneratedMatch.new(1, 3),
          Generator::GeneratedMatch.new(2, 3),
          Generator::GeneratedMatch.new(4, 5),
          Generator::GeneratedMatch.new(2, 5),
        ]

        sorted = generator.sort_within_event(event_games)

        competitors_in_first_three_matches = sorted[0..2].inject([]) do |acc, match|
          acc << match.team_1
          acc << match.team_2

          acc
        end

        expect(competitors_in_first_three_matches.uniq.sort).to eq([1,2,3,4,5])
      end
    end
  end
end
