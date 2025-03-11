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
      [125, 1, [
        ["Matt Ramos", "Purdue"],
        ["Luke Lilledahl", "Penn State"],
      ]],
      [133, 5, [
        ["Drake Ayala", "Iowa"],
        ["Lucas Byrd", "Illinois"],
      ]],
      [141, 7, [
        ["Brock Hardy", "Nebraska"],
        ["Andrew Alirez", "Northern Colorado"],
      ]],
      [149, 7, [
        ["Caleb Henson", "Virginia Tech"],
        ["Ridge Lovett", "Nebraska"],
      ]],
      [157, 7, [
        ["Tyler Kasak", "Penn State"],
        ["Meyer Shapiro", "Cornell"],
      ]],
      [165, 7, [
        ["Mitchell Mesenbrink", "Penn State"],
        ["Michael Caliendo", "Iowa"],
      ]],
      [174, 7, [
        ["Keegan O'Toole", "Missouri"],
        ["Levi Haines", "Penn State"],
      ]],
      [184, 6, [
        ["Carter Starocci", "Penn State"],
        ["Parker Keckeison", "UNI"],
      ]],
      [197, 6, [
        ["Jacob Cardenas", "Michigan"],
        ["Stephen Buchanan", "Iowa"],
      ]],
      [285, 5, [
        ["Gable Steveson", "Minnesota"],
        ["Greg Kerkfleit", "Penn State"],
      ]],
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

    users.each do |user|
      wager = ["home", "away"].shuffle.first
      WrestleBet::PropBet.create!(
        user: user,
        tournament: tournament,
        jesus: (1..5).to_a.shuffle.first,
        exposure: (1..5).to_a.shuffle.first,
        challenges: (1..5).to_a.shuffle.first,
      )
    end
  end
end
