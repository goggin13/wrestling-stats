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
RAILS_ENV=development bundle exec rake advocate:import_schedule[spec/download_fixtures/advocate/schedule_3_31.html] 
RAILS_ENV=test bundle exec rspec

# Dumbledore
- Silo JS and CSS files between apps
