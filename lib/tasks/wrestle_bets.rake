namespace :wrestle_bet do
  desc "Scrape Latest Individual and Team Rankings from Intermat"
  task import_wrestlers: :environment do
    [
      ["Gable Steveson", "Minnesota"],
      ["Greg Kerkfleit", "Penn State"],
      ["Carter Starocci", "Penn State"],
      ["Parker Keckeison", "UNI"],
      ["Mitchell Mesenbring", "Penn State"],
      ["Michael Caliendo", "Iowa"],
    ].each do |name, college_name|
      college = College.where(name: college_name).first!
      WrestleBet::Wrestler.create!(
        name: name,
        college: college
      )
    end
  end
end
