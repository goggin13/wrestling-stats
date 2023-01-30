desc "Olympics Bracket Tasks"
namespace :olympics do
  desc "import matches"
  task :import_matches, [:path] => :environment do |t, args|
    Olympics::MatchService.import_from_file(args.path)
  end

  desc "Generate brackets"
  task :generate, [] => :environment do |t, args|
    Olympics::Generator.generate_matchups
  end
end
