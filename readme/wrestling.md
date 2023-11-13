# Wrestling
* Up Next
Team Logos
Add links to team pages
Wrestlers to watch list (starred wrestlers)
Sort schedule within a day by "best matches" (sum of ranks asc?)
Attempt some schedule scraping. Or at least list teams to manually scrape
Namespace Wrestling Items? .... or leave it?

* Maybe
- logos for networks
- logos for teams
- add matches to Google Calendar? (would need times...)
- track rankings over time?  (rankings with date table instead of on wrestler?)

X - Highlight top 10 matchups
X - Team rankings page.
X - Auto-update rankings

Google Doc for raw schedule:
https://docs.google.com/spreadsheets/d/18UGHTlAAwXFuMBU_lxElWh-hpKd_0cCMU-sY496Xtkw/edit#gid=0
place in app/models/raw_schedule.rb
run RAILS_ENV=development bundle exec rake schedule:ingest
