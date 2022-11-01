# README
* Up Next
Team Logos
Add links to team pages
Wrestlers to watch list (starred wrestlers)
Sort schedule within a day by "best matches" (sum of ranks asc?)
Attempt some schedule scraping. Or at least list teams to manually scrape

* Maybe
- Only show top ten matchups for two weeks out
- logos for networks
- logos for teams
- add matches to Google Calendar? (would need times...)
- track rankings over time?  (rankings with date table instead of on wrestler?)

X - Highlight top 10 matchups
X - Team rankings page.
X - Auto-update rankings

Google Doc for raw schedule:
https://docs.google.com/spreadsheets/d/18UGHTlAAwXFuMBU_lxElWh-hpKd_0cCMU-sY496Xtkw/edit#gid=0

# Getting Started in development
./docker/build_and_tag.sh
./docker/start_app.sh

In a new pane
./docker/exec_db.sh
psql -Upostgres
CREATE USER wrestlingstats login createdb;

In a new pane
./docker/exec.sh
bundle exec rake db:create
RAILS_ENV=development bin/rails db:migrate 
RAILS_ENV=development bundle exec rake schedule:ingest
RAILS_ENV=test bundle exec rspec
