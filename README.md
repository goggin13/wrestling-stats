# README
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

# Getting Started in development
./docker/build_and_tag.sh
./docker/start_app.sh

In a new pane
./docker/exec_db.sh
psql -Upostgres
psql -Upostgres
CREATE USER dumbledore login createdb;
\password dumbdledore
  <dumbledore_development>

In a new pane
./docker/exec.sh
bundle exec rake db:create
RAILS_ENV=development bin/rails db:migrate 
RAILS_ENV=development bundle exec rake schedule:ingest
RAILS_ENV=development bundle exec rake rankings:update
RAILS_ENV=test bundle exec rspec








### LOMD 

#### ToDo
---- Must do ----
Work on tiebreaking and displaying
- tiebreaker algo
  - is there one team that is better than the rest?
  - pull them out and put them at the top
  - repeat

Advance teams by event until last game in event is played
Make it pretty (dark background)
Fade in scoreboard one row at a time
X - prompt for BP cups 
X - don't let a team be now_playing twice
X - scoreboard accounts for simple tiebreakers
Have a testing party

---- nice to do ----
Generate brackets page
E2E testing

#### tables
teams
name, number

matches
home_team_id, away_team_id, winner_id, game {ENUM}, bp_cups_remaining

#### homepage

scoreboard
- display tiebreaker data in subdued rows
- head-to-head, BP cups

table 1 playing
table 2 playing

on deck
second on deck
in the hole

rotating head-to-head tiebreaker banner
