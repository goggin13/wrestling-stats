class WrestleBet::Leaderboard
  def self.score_for_user(user)
    leaderboard = WrestleBet::Leaderboard.new(WrestleBet::Tournament.first!)

    leaderboard.score_for_user(user)
  end

  def initialize(tournament)
    @tournament = tournament
    _init_scores
  end

  def users
    @scores.keys.sort_by do |a|
      @scores[a]
    end.reverse
  end

  def _init_scores
    @scores = {}
    @scores_by_user_weight = {}
    @props_for_user = {}

    @tournament.matches.each do |match|
      match.bets.each do |bet|
        @scores_by_user_weight[bet.user] ||= {}
        @scores_by_user_weight[bet.user][match.weight] = bet.won? ? 1 : 0

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

      @props_for_user[bet.user] = {
        jesus: bet.won_jesus? ? 1 : 0,
        challenges: bet.won_challenges? ? 1 : 0,
        exposure: bet.won_exposure? ? 1 : 0,
      }
    end
  end

  def score_for_user(user)
    @scores[user]
  end

  def user_in_first_place?(user)
    max_score = @scores.values.max
    return false if max_score == 0

    score_for_user(user) == max_score
  end

  def score_for_weight(user, weight)
    @scores_by_user_weight[user][weight]
  end

  def score_for_prop(user, prop)
    return 0 unless @tournament.completed?

    @props_for_user[user][prop]
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
