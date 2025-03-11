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

  desc "Assign logos to colleges"
  task import_logos: :environment do
    {
      "Cornell" => "https://content.sportslogos.net/logos/30/651/thumbs/65139712002.gif",
      "Illinois" => "https://content.sportslogos.net/logos/32/706/thumbs/70667432022.gif",
      "Iowa" => "https://content.sportslogos.net/logos/32/712/thumbs/71241981979.gif",
      "Michigan" => "https://content.sportslogos.net/logos/32/750/thumbs/75086742016.gif",
      "Minnesota" => "https://content.sportslogos.net/logos/32/753/thumbs/75397141986.gif",
      "Missouri" => "https://content.sportslogos.net/logos/32/757/thumbs/75718052018.gif",
      "Nebraska" => "https://content.sportslogos.net/logos/33/766/thumbs/76662700.gif",
      "Northern Colorado" => "https://content.sportslogos.net/logos/33/4954/thumbs/495412272010.gif",
      "Penn State" => "https://content.sportslogos.net/logos/33/801/thumbs/80145772005.gif",
      "Purdue" => "https://content.sportslogos.net/logos/33/809/thumbs/80917862012.gif",
      "UNI" => "https://content.sportslogos.net/logos/33/786/thumbs/78670852021.gif",
      "Virginia Tech" => "https://content.sportslogos.net/logos/35/901/thumbs/90121061983.gif",
    }.each do |name, logo_url|
      college = College.where(name: name).first!
      college.logo.attach(io: URI.open(logo_url), filename: name)
    end
  end
end
