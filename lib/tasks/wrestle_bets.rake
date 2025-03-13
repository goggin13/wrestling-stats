namespace :wrestle_bet do
  def sleep_in_production
    sleep_time = if ENV.has_key?("SLEEP_TIME")
      ENV["SLEEP_TIME"].to_i
    else
      10
    end
    sleep(sleep_time) if Rails.env.production?
  end

  task reset: :environment do
    Rake::Task["wrestle_bet:reset_data"].invoke
    Rake::Task["wrestle_bet:import_images"].invoke
  end

  desc "Scrape Latest Individual and Team Rankings from Intermat"
  task reset_data: :environment do
    WrestleBet::Tournament.destroy_all
    WrestleBet::Match.destroy_all
    # WrestleBet::Wrestler.destroy_all
    WrestleBet::SpreadBet.destroy_all
    WrestleBet::PropBet.destroy_all

    tournament = WrestleBet::Tournament.create!(
      name: "2025 NCAA",
      jesus: 5,
      exposure: 3,
      challenges: 5,
    )


    users = [
      {email: "klynch425@gmail.com", handle: "Kelly", file: "kelly.png"},
      {email: "lucaslemanski2@gmail.com", handle: "Lucas", file: "luke.png"},
      {email: "choy.ash831@gmail.com", handle: "Ashley", file: "ashley.png"},
      {email: "danstipanuk@gmail.com", handle: "Dan", file: "dan.jpg"},
      {email: "katepotteiger@gmail.com", handle: "Kate", file: "kate.png"},
      {email: "seg12@cornell.edu", handle: "Goggin SR", file: "steve.png"},
      {email: "cookediana@gmail.com", handle: "Diana", file: "diana.png"},
      {email: "cepluard@gmail.com", handle: "Claire", file: "claire.png"},
      {email: "tworhach35@gmail.com", handle: "Tom", file: "tom.png"}
    ].map do |user_data|
      user = User.where(email: user_data[:email]).first
      if user.present?
        user
        user.update(handle: user_data[:handle])
      else
        password = SecureRandom.hex(8)
        puts user_data
        user = User.create!(
          :email => user_data[:email],
          :password => password,
          :password_confirmation => password,
          :handle => user_data[:handle]
        )
      end

      if !user.avatar.attached? || ENV["REFRESH_IMAGES"].present?
        image_path = Rails.root.join("app", "assets", "images", "wrestle_bet", "avatars", user_data[:file])
        puts "attaching #{image_path}"
        user.avatar.attach(io: File.open(image_path), filename: user_data[:file])
        sleep_in_production
      end

      user
    end

    goggin = User.where(email: "goggin13@gmail.com").first!
    image_path = Rails.root.join("app", "assets", "images", "wrestle_bet", "avatars", "matt.png")
    goggin.avatar.attach(io: File.open(image_path), filename: "matt.png")
    goggin.update(handle: "Goggin JR")
    sleep_in_production
    users << goggin

    # spread is always from POV of home wrestler
    # if you always make home wrestler the favorite, all spreads are (-)
      # otherwise, (-) spread is home favored, (+) spread is away favored
    [
      [125, 1.5, [
        ["Matt Ramos", "Purdue"],
        ["Luke Lilledahl", "Penn State"],
      ]],
      [133, 0.5, [
        ["Drake Ayala", "Iowa"],
        ["Lucas Byrd", "Illinois"],
      ]],
      [141, 2.5, [
        ["Brock Hardy", "Nebraska"],
        ["Andrew Alirez", "Northern Colorado"],
      ]],
      [149, -1.5, [
        ["Caleb Henson", "Virginia Tech"],
        ["Ridge Lovett", "Nebraska"],
      ]],
      [157, -4.5, [
        ["Tyler Kasak", "Penn State"],
        ["Meyer Shapiro", "Cornell"],
      ]],
      [165, -10.5, [
        ["Mitchell Mesenbrink", "Penn State"],
        ["Michael Caliendo", "Iowa"],
      ]],
      [174, -1.5, [
        ["Keegan O'Toole", "Missouri"],
        ["Levi Haines", "Penn State"],
      ]],
      [184, -2.5, [
        ["Carter Starocci", "Penn State"],
        ["Parker Keckeison", "UNI"],
      ]],
      [197, -1.5, [
        ["Jacob Cardenas", "Michigan"],
        ["Stephen Buchanan", "Iowa"],
      ]],
      [285, -7.5, [
        ["Gable Steveson", "Minnesota"],
        ["Greg Kerkfleit", "Penn State"],
      ]],
    ].each do |weight, spread, wrestler_data|
      wrestlers = wrestler_data.map do |name, college_name|
        college = College.find_by_corrected_name!(college_name)
        WrestleBet::Wrestler.find_or_create_by(
          name: name,
          college: college
        )
      end

      home_score, away_score = (1..15).to_a.shuffle[0..1]
      match = WrestleBet::Match.create!(
        weight: weight,
        spread: spread,
        home_wrestler: wrestlers[0],
        away_wrestler: wrestlers[1],
        # home_score: home_score,
        # away_score: away_score,
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

  desc "Assign avatars to wrestlers, logos to colleges"
  task import_images: :environment do
    {
      "Luke Lilledahl" => "https://bloximages.newyork1.vip.townnews.com/psucollegian.com/content/tncms/assets/v3/editorial/8/c5/8c592f50-bb2f-11ef-a6f1-ab4b8287cfd2/675f50bc694bd.image.jpg?resize=1396%2C983",
      "Drake Ayala" => "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9z3aSZBSTtAC-fm4WpicdbFvSU9jbxviesQ&s",
      "Lucas Byrd" => "https://images.sidearmdev.com/convert?url=https%3A%2F%2Fdxbhsrqyrr690.cloudfront.net%2Fsidearm.nextgen.sites%2Ffightingillini.com%2Fimages%2F2025%2F1%2F30%2F20250110_WRES_vs_OhioState_KS_0412.jpg&type=webp",
      "Ridge Lovett" => "https://bloximages.chicago2.vip.townnews.com/nptelegraph.com/content/tncms/assets/v3/editorial/9/ea/9ea4b4d7-3ced-5d8a-aa03-845902cac8e0/62130aecb9723.image.jpg?resize=751%2C500",
      "Caleb Henson" => "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQyGs3QdSbhAKdVfWANIdqRtXRBZtZy4GV4Fg&s",
      "Tyler Kasak" => "https://www.pennlive.com/resizer/rPd1NIB6NCxrRLA2gqfyulEnrp0=/arc-anglerfish-arc2-prod-advancelocal/public/ORZM4POW7FGX7DR3B4HYGZH5BA.jpg",
      "Meyer Shapiro" => "https://d2779tscntxxsw.cloudfront.net/6255d87ad17da.png?width=1200&quality=80",
      "Mitchell Mesenbrink" => "https://www.statecollege.com/wp-content/uploads/2024/03/mesenbrink-aidan-conrad.jpeg",
      "Michael Caliendo" => "https://images.sidearmdev.com/convert?url=https%3A%2F%2Fdxbhsrqyrr690.cloudfront.net%2Fsidearm.nextgen.sites%2Fgobison.sidearmsports.com%2Fimages%2F2022%2F11%2F4%2F1M2A9668_oVCJM.JPG&type=webp",
      "Keegan O'Toole" => "https://www.columbiatribune.com/gcdn/presto/2023/03/20/PMJS/caa10295-5c51-49b8-866f-afbca81f31ef-USATSI_20264619.jpg",
      "Levi Haines" => "https://www.yorkdispatch.com/gcdn/authoring/authoring-images/2024/03/24/PPYD/73083591007-ap-24084150331129.jpg?width=1200&disable=upscale&format=pjpg&auto=webp",
      "Carter Starocci" => "https://www.baschamania.com/static/sitefiles/podcast/carterstarocci-web.png",
      "Parker Keckeison" => "https://images.sidearmdev.com/resize?url=https%3A%2F%2Funipanthers.com%2Fimages%2F2024%2F12%2F7%2F11-24-24_UNI_v._SDSU-24_uFgxR.jpg&width=1600",
      "Stephen Buchanan" => "https://image-cdn.essentiallysports.com/wp-content/uploads/Stephen-Buchana-e1723573431335.jpg",
      "Gable Steveson" => "https://img.olympics.com/images/image/private/t_s_pog_staticContent_hero_lg_2x/f_auto/primary/eguu89dfco7qzu3s1hae",
      "Greg Kerkfleit" => "https://www.ydr.com/gcdn/authoring/authoring-images/2024/03/24/PPYR/73083946007-kerk.jpg?crop=3642,2049,x0,y0&width=3200&height=1801&format=pjpg&auto=webp",
      "Jacob Cardenas" => "https://d2779tscntxxsw.cloudfront.net/66102e66a1754.png",
      "Brock Hardy" => "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVVArcNm2xS7ZhXw6w-umHSjxpHRbVjexAsA&s",
      "Andrew Alirez" => "https://d2779tscntxxsw.cloudfront.net/64a711eaf22fa.png?width=650&quality=80 ",
      "Matt Ramos" => "https://images.sidearmdev.com/resize?url=https%3A%2F%2Fdxbhsrqyrr690.cloudfront.net%2Fsidearm.nextgen.sites%2Fpurduesports.com%2Fimages%2F2023%2F3%2F17%2F_N8Q1934-3.jpg&height=300&type=webp",
    }.each do |name, avatar_url|
      puts name
      wrestler = WrestleBet::Wrestler.where(name: name).first!
      if ENV["REFRESH_IMAGES"].present? || !wrestler.avatar.attached?
        puts "\tattaching #{avatar_url}"
        wrestler.avatar.attach(io: URI.open(avatar_url), filename: name)
        sleep_in_production
      else
        puts "\tavatar attached"
      end
    end

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
      college = College.find_by_corrected_name!(name)
      puts name
      if ENV["REFRESH_IMAGES"].present? || !college.logo.attached?
        puts "\tattaching #{logo_url}"
        college.logo.attach(io: URI.open(logo_url), filename: name)
        sleep_in_production
      else
        puts "\tlogo attached"
      end
    end
  end
end
