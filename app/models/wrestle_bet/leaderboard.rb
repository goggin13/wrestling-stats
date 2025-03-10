class WrestleBet::Leaderboard
  def initialize(tournament)
    @tournament = tournament
    _init_scores
  end

  def _init_scores
    @scores = {}

    @tournament.matches.each do |match|
      match.bets.each do |bet|
        @scores[bet.user] ||= 0
        if bet.won?
          @scores[bet.user] += 1
        end
      end
    end
  end

  def rankings
    rankings = {}

    @scores.inject({}) do |acc, (user, score)|
      acc[score] ||= []
      acc[score] << user

      acc
    end.sort_by { |score, users| score }
      .reverse
      .each_with_index do |score_with_users, index|
        points = score_with_users[0]
        users = score_with_users[1]
        rankings[index + 1] = {
          points: points,
          users: users,
        }
      end

    rankings
  end
end
