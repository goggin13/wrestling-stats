class WrestleBet::Leaderboard
  def self.score_for_user(user)
    leaderboard = WrestleBet::Leaderboard.new(WrestleBet::Tournament.first!)

    leaderboard.score_for_user(user)
  end

  def initialize(tournament)
    @tournament = tournament
    _init_scores
  end

  def _init_scores
    @scores = {}

    @tournament.matches.each do |match|
      match.bets.each do |bet|
        @scores[bet.user] ||= 0
        @scores[bet.user] += 1 if bet.won?
      end
    end

    return unless @tournament.completed?

    @tournament.prop_bets.each do |bet|
      @scores[bet.user] ||= 0
      @scores[bet.user] += 1 if bet.won_jesus?
      @scores[bet.user] += 1 if bet.won_challenges?
      @scores[bet.user] += 1 if bet.won_exposure?
    end
  end

  def score_for_user(user)
    @scores[user]
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
