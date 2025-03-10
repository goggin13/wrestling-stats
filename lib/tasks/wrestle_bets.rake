namespace :wrestle_bet do
  desc "Scrape Latest Individual and Team Rankings from Intermat"
  task reset_all: :environment do
    WrestleBet::Tournament.destroy_all
    WrestleBet::Match.destroy_all
    WrestleBet::Wrestler.destroy_all
    WrestleBet::SpreadBet.destroy_all

    tournament = WrestleBet::Tournament.create!(name: "2025 NCAA")

    users = [
      "rudolphocisneros@gmail.com",
      "klynch425@gmail.com",
      "lucaslemanski2@gmail.com",
      "choy.ash831@gmail.com",
      "erinumhoefer@gmail.com",
      "katepotteiger@gmail.com",
      "seg12@cornell.edu"
    ].map do |email|
      user = User.where(email: email).first
      if user.present?
        user
      else
        password = SecureRandom.hex(8)
        User.create!(
          :email => email,
          :password => password,
          :password_confirmation => password,
        )
      end
    end

    users << User.where(email: "goggin13@gmail.com").first!

    [
      [285, 5, [
        ["Gable Steveson", "Minnesota"],
        ["Greg Kerkfleit", "Penn State"],
      ]],
      [184, 6, [
        ["Carter Starocci", "Penn State"],
        ["Parker Keckeison", "UNI"],
      ]],
      [165, 7, [
        ["Mitchell Mesenbring", "Penn State"],
        ["Michael Caliendo", "Iowa"],
      ]]
    ].each do |weight, spread, wrestler_data|
      wrestlers = wrestler_data.map do |name, college_name|
        college = College.where(name: college_name).first!
        WrestleBet::Wrestler.create!(
          name: name,
          college: college
        )
      end

      match = WrestleBet::Match.create!(
        weight: weight,
        spread: spread,
        home_wrestler: wrestlers[0],
        away_wrestler: wrestlers[1],
        tournament: tournament,
      )

      users.each do |user|
        wager = ["home", "away"].shuffle.first
        WrestleBet::SpreadBet.create!(
          user: user,
          match: match,
          wager: wager
        )
      end
    end
  end
end
