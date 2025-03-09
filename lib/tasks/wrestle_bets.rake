namespace :wrestle_bet do
  desc "Scrape Latest Individual and Team Rankings from Intermat"
  task import_wrestlers: :environment do
    WrestleBet::Tournament.destroy_all
    WrestleBet::Match.destroy_all
    WrestleBet::Wrestler.destroy_all

    tournament = WrestleBet::Tournament.create!(name: "2025 NCAA")

    [
      [285, [
        ["Gable Steveson", "Minnesota"],
        ["Greg Kerkfleit", "Penn State"],
      ]],
      [184, [
        ["Carter Starocci", "Penn State"],
        ["Parker Keckeison", "UNI"],
      ]],
      [165, [
        ["Mitchell Mesenbring", "Penn State"],
        ["Michael Caliendo", "Iowa"],
      ]]
    ].each do |weight, wrestler_data|
      wrestlers = wrestler_data.map do |name, college_name|
        college = College.where(name: college_name).first!
        WrestleBet::Wrestler.create!(
          name: name,
          college: college
        ).tap { |x|  puts x }
      end

      WrestleBet::Match.create!(
        weight: weight,
        home_wrestler: wrestlers[0],
        away_wrestler: wrestlers[1],
        tournament: tournament,
      ).tap { |x|  puts x }
    end
  end
end
